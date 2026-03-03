DROP TABLE IF EXISTS stream_flink_input;

CREATE TABLE stream_flink_input (
    id INT,
    name STRING,
    gender STRING,
    age INT
) WITH (
    'connector' = 'kafka',
    'topic' = 'my-stream-flink-sql-input',
    'properties.bootstrap.servers' = 'broker:29092',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json'
);

DROP TABLE IF EXISTS stream_flink_output;

CREATE TABLE stream_flink_output (
    name STRING,
    gender STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'my-stream-flink-sql-output',
    'properties.bootstrap.servers' = 'broker:29092',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json'
);

INSERT INTO stream_flink_output
SELECT name, gender
FROM stream_flink_input
WHERE gender = 'M' OR gender = 'X';
