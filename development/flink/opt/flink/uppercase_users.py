from pyflink.table import EnvironmentSettings, TableEnvironment
from pyflink.table.expressions import col
from pyflink.table.udf import udf
from pyflink.table.types import DataTypes

# ---------------------------------------------------
# 1. Pythonで独自のデータ変換関数（UDF）を定義する
# ---------------------------------------------------

@udf(result_type=DataTypes.STRING())
def process_name(name: str) -> str:
    """名前を大文字にし、空白を除去するPython関数"""
    if name is None:
        return "UNKNOWN"
    return name.strip().upper()

@udf(result_type=DataTypes.STRING())
def process_message(msg: str) -> str:
    """メッセージを装飾するPython関数"""
    if msg is None:
        return "No message"
    # ここに外部APIを叩く処理や、複雑な正規表現による編集なども書けます
    return f"Python Edited: {msg.strip()}"

# ---------------------------------------------------
# 2. メインの処理フロー
# ---------------------------------------------------

def main():
    env_settings = EnvironmentSettings.in_streaming_mode()
    t_env = TableEnvironment.create(env_settings)

    # 入出力の「接続設定」だけはDDL（SQL）で定義するのがPyFlinkの標準的な手法です
    t_env.execute_sql("""
        CREATE TABLE source_table (
            user_name STRING,
            message STRING
        ) WITH (
            'connector' = 'kafka',
            'topic' = 'my-stream-flink-job-input',
            'properties.bootstrap.servers' = 'broker:29092',
            'properties.group.id' = 'pyflink-group',
            'scan.startup.mode' = 'earliest-offset',
            'format' = 'csv'
        )
    """)

    t_env.execute_sql("""
        CREATE TABLE sink_table (
            user_name_upper STRING,
            processed_message STRING
        ) WITH (
            'connector' = 'kafka',
            'topic' = 'my-stream-flink-job-output',
            'properties.bootstrap.servers' = 'broker:29092',
            'format' = 'csv'
        )
    """)

    print("Starting PyFlink Job with Python Functions...")

    # 3. SQLではなく、Pythonのコードでデータ処理の流れ（パイプライン）を構築する
    
    # テーブルのオブジェクトを取得
    source = t_env.from_path("source_table")

    # Pythonで定義した関数（UDF）を適用してデータを変換
    transformed_data = source.select(
        process_name(col("user_name")).alias("user_name_upper"),
        process_message(col("message")).alias("processed_message")
    )

    # 変換したデータを出力先へ流し込む（実行）
    transformed_data.execute_insert("sink_table")

if __name__ == '__main__':
    main()
