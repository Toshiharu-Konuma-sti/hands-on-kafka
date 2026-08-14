import json
from pyflink.datastream import StreamExecutionEnvironment
from pyflink.datastream.connectors.kafka import KafkaSource, KafkaOffsetsInitializer
from pyflink.common.serialization import SimpleStringSchema
from pyflink.common.watermark_strategy import WatermarkStrategy
from pyflink.common.typeinfo import Types
from pyflink.table import StreamTableEnvironment
from pyflink.table.expressions import col as tcol

# ---------------------------------------------------
# 1. 変換処理を「普通のPython関数」として定義する
#    Table APIの @udf デコレータは不要
# ---------------------------------------------------

def process(json_str: str):
    """swapcase + 性別に応じた敬称を付与する（空入力・不正入力はスキップ）"""
    if not json_str or not json_str.strip():
        return
    try:
        data = json.loads(json_str)
    except (json.JSONDecodeError, TypeError):
        return

    name = data.get("name", "")
    gender = data.get("gender", "")

    swapped = name.swapcase()
    if gender == "M":
        name_out = f"Mr. {swapped}"
    elif gender == "F":
        name_out = f"Ms. {swapped}"
    elif gender == "X":
        name_out = f"{swapped} - san"
    else:
        name_out = swapped

    yield json.dumps({
        "id": data.get("id"),
        "name": name_out,
        "gender": gender.swapcase(),
        "age": data.get("age")
    }, ensure_ascii=False)


# ---------------------------------------------------
# 2. メインの処理フロー
# ---------------------------------------------------

def main():
    # Table APIの TableEnvironment とは異なる低レベルAPIのエントリポイント
    env = StreamExecutionEnvironment.get_execution_environment()
    # KafkaSink の型変換問題を回避するため Table API とのブリッジ環境を用意する
    t_env = StreamTableEnvironment.create(env)

    # 出力: Table API DDL でシンクを定義（'raw' format で String を直接バイト列として書き込む）
    t_env.execute_sql("""
        CREATE TABLE sink_table (
            `value` STRING
        ) WITH (
            'connector' = 'kafka',
            'topic' = 'my-flink-datastream-api-output',
            'properties.bootstrap.servers' = 'kafka:29092',
            'format' = 'raw'
        )
    """)

    # 入力: KafkaSourceをビルダーパターンで構築（Table APIのDDL "CREATE TABLE" は不要）
    source = KafkaSource.builder() \
        .set_bootstrap_servers("kafka:29092") \
        .set_topics("my-flink-input") \
        .set_group_id("datastream-group") \
        .set_starting_offsets(KafkaOffsetsInitializer.earliest()) \
        .set_value_only_deserializer(SimpleStringSchema()) \
        .build()

    print("Starting PyFlink DataStream API Job...")

    # 3. DataStreamパイプラインの構築
    #    Table APIの .select(udf(...)) と異なり、レコード単位の関数変換で組み立てる
    ds = env.from_source(source, WatermarkStrategy.no_watermarks(), "Kafka Source")
    processed_ds = ds.flat_map(process, output_type=Types.STRING())

    # DataStream を Table に変換してシンクへ流し込む
    # Table APIと異なり、execute_insert() で明示的に実行する
    t_env.from_data_stream(processed_ds, tcol("value")).execute_insert("sink_table")


if __name__ == "__main__":
    main()
