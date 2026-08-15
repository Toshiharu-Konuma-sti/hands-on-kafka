import json
from pyflink.datastream import StreamExecutionEnvironment, KeyedProcessFunction
from pyflink.datastream.connectors.kafka import KafkaSource, KafkaOffsetsInitializer
from pyflink.datastream.state import ValueStateDescriptor
from pyflink.common.serialization import SimpleStringSchema
from pyflink.common.watermark_strategy import WatermarkStrategy
from pyflink.common.typeinfo import Types
from pyflink.table import StreamTableEnvironment
from pyflink.table.expressions import col as tcol

# ---------------------------------------------------
# 1. key_by 用のキー抽出関数
# ---------------------------------------------------

def extract_gender_key(json_str: str) -> str:
    """gender 値を keyed state のキーとして返す"""
    try:
        return json.loads(json_str).get("gender", "UNKNOWN") if json_str else "UNKNOWN"
    except (json.JSONDecodeError, TypeError):
        return "UNKNOWN"


# ---------------------------------------------------
# 2. ステートフル変換: 性別グループごとの累積平均年齢と比較
#    Table API では実現できない「レコードをまたいだ状態保持」を行う
# ---------------------------------------------------

class AgeStatsProcessor(KeyedProcessFunction):

    def open(self, runtime_context):
        # gender キーごとに独立して永続化されるステート
        self.age_sum = runtime_context.get_state(
            ValueStateDescriptor("age_sum", Types.LONG()))
        self.age_count = runtime_context.get_state(
            ValueStateDescriptor("age_count", Types.LONG()))

    def process_element(self, value, ctx):
        if not value or not value.strip():
            return
        try:
            data = json.loads(value)
        except (json.JSONDecodeError, TypeError):
            return

        name = data.get("name", "")
        gender = data.get("gender", "")
        age = data.get("age")

        # 不正な age はレコードごと除去
        if age is None or not isinstance(age, int) or age < 0 or age > 120:
            return

        swapped = name.swapcase()
        if gender == "M":
            name_out = f"Mr. {swapped}"
        elif gender == "F":
            name_out = f"Ms. {swapped}"
        elif gender == "X":
            name_out = f"{swapped} - san"
        else:
            name_out = swapped

        current_sum = self.age_sum.value() or 0
        current_count = self.age_count.value() or 0
        current_sum += age
        current_count += 1
        self.age_sum.update(current_sum)
        self.age_count.update(current_count)

        running_avg = current_sum / current_count
        if age > running_avg:
            vs_avg = "above"
        elif age < running_avg:
            vs_avg = "below"
        else:
            vs_avg = "equal"

        yield json.dumps({
            "id": data.get("id"),
            "name": name_out,
            "gender": gender.swapcase(),
            "age": age,
            "vs_avg": vs_avg,
            "avg_age": round(running_avg, 1)
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
        CREATE TABLE flink_datastream_api_sink (
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
    #    gender でキー付けし、性別グループごとのステートフル処理を適用する
    ds = env.from_source(source, WatermarkStrategy.no_watermarks(), "Kafka Source")
    result_ds = (
        ds
        .key_by(extract_gender_key, key_type=Types.STRING())
        .process(AgeStatsProcessor(), output_type=Types.STRING())
    )

    t_env.from_data_stream(result_ds, tcol("value")).execute_insert("flink_datastream_api_sink")


if __name__ == "__main__":
    main()
