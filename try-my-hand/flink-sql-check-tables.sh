#!/bin/sh

SQL_FILE=$(mktemp /tmp/flink_check_XXXXXX.sql)
trap 'docker exec jobmanager rm -f /tmp/flink_check.sql; rm -f "$SQL_FILE"' EXIT

cat > "$SQL_FILE" << 'FLINK_SQL'
SET sql-client.execution.result-mode=TABLEAU;

DROP TABLE IF EXISTS streams_flink_input;

CREATE TABLE streams_flink_input (
    id INT,
    name STRING,
    gender STRING,
    age INT
) WITH (
    'connector' = 'kafka',
    'topic' = 'my-stream-flink-input',
    'properties.bootstrap.servers' = 'kafka:29092',
    'scan.startup.mode' = 'earliest-offset',
    'scan.bounded.mode' = 'latest-offset',
    'format' = 'json'
);

DROP TABLE IF EXISTS streams_flink_output;

CREATE TABLE streams_flink_output (
    name STRING,
    gender STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'my-stream-flink-sql-output',
    'properties.bootstrap.servers' = 'kafka:29092',
    'scan.startup.mode' = 'earliest-offset',
    'scan.bounded.mode' = 'latest-offset',
    'format' = 'json'
);

SHOW TABLES;

SELECT * FROM streams_flink_input;

SELECT * FROM streams_flink_output;
FLINK_SQL

docker cp "$SQL_FILE" jobmanager:/tmp/flink_check.sql
docker exec jobmanager ./bin/sql-client.sh -f /tmp/flink_check.sql
