from pyflink.table import EnvironmentSettings, TableEnvironment
from pyflink.table.expressions import col
from pyflink.table.udf import udf
from pyflink.table.types import DataTypes

# ---------------------------------------------------
# 1. Pythonで独自のデータ変換関数（UDF）を定義する (Transform処理)
# ---------------------------------------------------

@udf(result_type=DataTypes.STRING())
def process_name(name: str) -> str:
    """
    名前データに対するデータクレンジングと名寄せ（標準化）処理
    """
    # 1. 欠損値（Null）のハンドリング
    if not name or name.strip() == "":
        return "UNKNOWN_USER"

    # 2. データクレンジング（前後の空白除去、小文字化して扱いやすくする）
    raw_name = name.strip().lower()

    # 3. 不正文字やノイズの除去（例：システム混入のアンダーバーを消す）
    cleaned_name = raw_name.replace("_", "")

    # 4. ビジネスルールに基づく名寄せ・変換
    if cleaned_name.startswith("test"):
        return "TEST_ACCOUNT"
    elif cleaned_name == "admin":
        return "ADMINISTRATOR"

    # 5. 最終フォーマット（大文字）に整えて出力
    return cleaned_name.upper()

@udf(result_type=DataTypes.STRING())
def process_message(msg: str) -> str:
    """
    メッセージに対するマスキングとデータエンリッチメント（付加価値向上）処理
    """
    if not msg:
        return "[EMPTY_DATA]"

    text = msg.strip()

    # 1. セキュリティ処理：個人情報(PII)やパスワードのマスキング
    if "password" in text.lower() or "secret" in text.lower():
        return "[REDACTED: SENSITIVE DATA HIDDEN]"

    # 2. データエンリッチメント：内容からカテゴリを推論して付与する
    category = "INFO"
    if "error" in text.lower() or "fail" in text.lower() or "fatal" in text.lower():
        category = "ALERT"
    elif "hello" in text.lower() or "hi" in text.lower():
        category = "GREETING"

    # 3. データの再構築（カテゴリタグを付与した構造化テキストに変換）
    transformed_result = f"[{category}] {text}"

    return transformed_result

# ---------------------------------------------------
# 2. メインの処理フロー (Extract -> Transform -> Load)
# ---------------------------------------------------

def main():
    env_settings = EnvironmentSettings.in_streaming_mode()
    t_env = TableEnvironment.create(env_settings)

    # [Extract] 入力元（Source）の定義：Kafkaからデータを抽出
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

    # [Load] 出力先（Sink）の定義：Kafkaへデータを書き出し
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

    print("Starting PyFlink ETL Pipeline...")

    # [Transform] 抽出したデータに対して、Pythonの関数を適用して変換する
    source = t_env.from_path("source_table")

    transformed_data = source.select(
        process_name(col("user_name")).alias("user_name_upper"),
        process_message(col("message")).alias("processed_message")
    )

    # [Load実行] 変換後のデータを出力先に流し込む
    transformed_data.execute_insert("sink_table")

if __name__ == '__main__':
    main()
