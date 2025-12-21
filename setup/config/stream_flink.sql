DROP TABLE IF EXISTS streams_flink_input;

CREATE TABLE streams_flink_input (
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

DROP TABLE IF EXISTS streams_flink_output;

CREATE TABLE streams_flink_output (
    name STRING,
    gender STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'my-stream-flink-sql-output',
    'properties.bootstrap.servers' = 'broker:29092',
    'scan.startup.mode' = 'earliest-offset',
    'format' = 'json'
);

INSERT INTO streams_flink_output
SELECT name, gender
FROM streams_flink_input
WHERE gender = 'M' OR gender = 'X';
