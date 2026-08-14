from pyflink.table import EnvironmentSettings, TableEnvironment
from pyflink.table.expressions import col
from pyflink.table.udf import udf
from pyflink.table.types import DataTypes

# ---------------------------------------------------
# 1. Pythonで独自のデータ変換関数（UDF）を定義する
# ---------------------------------------------------

@udf(result_type=DataTypes.STRING())
def process_name(name: str, gender: str) -> str:
    """swapcase後の名前に、元の性別値に応じた敬称を付与する"""
    if name is None:
        return "UNKNOWN"
    swapped = name.swapcase()
    if gender == "M":
        return f"Mr. {swapped}"
    elif gender == "F":
        return f"Ms. {swapped}"
    elif gender == "X":
        return f"{swapped} -san"
    return swapped

@udf(result_type=DataTypes.STRING())
def swapcase_str(s: str) -> str:
    """大文字↔小文字を反転する"""
    if s is None:
        return None
    return s.swapcase()

# ---------------------------------------------------
# 2. メインの処理フロー
# ---------------------------------------------------

def main():
    env_settings = EnvironmentSettings.in_streaming_mode()
    t_env = TableEnvironment.create(env_settings)

    # 入出力の「接続設定」だけはDDL（SQL）で定義するのがPyFlinkの標準的な手法です
    t_env.execute_sql("""
        CREATE TABLE flink_table_api_input (
            id INT,
            name STRING,
            gender STRING,
            age INT
        ) WITH (
            'connector' = 'kafka',
            'topic' = 'my-stream-flink-input',
            'properties.bootstrap.servers' = 'kafka:29092',
            'properties.group.id' = 'pyflink-group',
            'scan.startup.mode' = 'earliest-offset',
            'format' = 'json'
        )
    """)

    t_env.execute_sql("""
        CREATE TABLE flink_table_api_output (
            name STRING,
            gender STRING
        ) WITH (
            'connector' = 'kafka',
            'topic' = 'my-stream-flink-table-api-output',
            'properties.bootstrap.servers' = 'kafka:29092',
            'format' = 'json'
        )
    """)

    print("Starting PyFlink Job with Python Functions...")

    # 3. SQLではなく、Pythonのコードでデータ処理の流れ（パイプライン）を構築する

    # テーブルのオブジェクトを取得
    source = t_env.from_path("flink_table_api_input")

    # Pythonで定義した関数（UDF）を適用してデータを変換
    transformed_data = source.select(
        process_name(col("name"), col("gender")).alias("name"),
        swapcase_str(col("gender")).alias("gender")
    )

    # 変換したデータを出力先へ流し込む（実行）
    transformed_data.execute_insert("flink_table_api_output")

if __name__ == '__main__':
    main()
