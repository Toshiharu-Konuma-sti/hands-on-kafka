DROP TABLE IF EXISTS flink_sql_input;

CREATE TABLE flink_sql_input (
    id INT,
    name STRING,
    gender STRING,
    age INT
) WITH (
    'connector' = 'kafka',
    'topic' = 'my-flink-input',
    'properties.bootstrap.servers' = 'kafka:29092',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json'
);

DROP TABLE IF EXISTS flink_sql_output;

CREATE TABLE flink_sql_output (
    name STRING,
    gender STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'my-flink-sql-output',
    'properties.bootstrap.servers' = 'kafka:29092',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json'
);

INSERT INTO flink_sql_output
SELECT name, gender
FROM flink_sql_input
WHERE gender = 'M' OR gender = 'X';
