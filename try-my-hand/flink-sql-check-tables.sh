#!/bin/sh

SQL_FILE=$(mktemp /tmp/flink_check_XXXXXX.sql)
trap 'docker exec jobmanager rm -f /tmp/flink_check.sql; rm -f "$SQL_FILE"' EXIT

cat > "$SQL_FILE" << 'FLINK_SQL'
SET sql-client.execution.result-mode=TABLEAU;

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
    'scan.bounded.mode' = 'latest-offset',
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
    'scan.bounded.mode' = 'latest-offset',
    'format' = 'json'
);

SHOW TABLES;

SELECT * FROM flink_sql_input;

SELECT * FROM flink_sql_output;
FLINK_SQL

docker cp "$SQL_FILE" jobmanager:/tmp/flink_check.sql
docker exec jobmanager ./bin/sql-client.sh -f /tmp/flink_check.sql
