from pyflink.table import EnvironmentSettings, TableEnvironment

def main():
    # 1. Flink環境の設定
    env_settings = EnvironmentSettings.in_streaming_mode()
    t_env = TableEnvironment.create(env_settings)

    # 2. Sourceテーブル（入力元）の定義
    # 前回のSQL Clientと同じ設定です
    t_env.execute_sql("""
        CREATE TABLE source_table (
            user_name STRING,
            message STRING
        ) WITH (
            'connector' = 'kafka',
            'topic' = 'input-topic',
            'properties.bootstrap.servers' = 'broker:29092',
            'properties.group.id' = 'pyflink-group',
            'scan.startup.mode' = 'earliest-offset',
            'format' = 'csv'
        )
    """)

    # 3. Sinkテーブル（出力先）の定義
    # output-topic に書き込む設定です
    t_env.execute_sql("""
        CREATE TABLE sink_table (
            user_name_upper STRING,
            processed_message STRING
        ) WITH (
            'connector' = 'kafka',
            'topic' = 'output-topic',
            'properties.bootstrap.servers' = 'broker:29092',
            'format' = 'csv'
        )
    """)

    # 4. データ変換と転送 (ETL実行)
    # ここでSELECTした結果がINSERTされます
    print("Starting PyFlink Job...")
    
    t_env.execute_sql("""
        INSERT INTO sink_table
        SELECT 
            UPPER(user_name),           -- 名前を大文字に変換
            'Processed: ' || message    -- メッセージに文字を結合
        FROM source_table
    """)

if __name__ == '__main__':
    main()
