#!/bin/sh

SQL_FILE=$(mktemp /tmp/flink_check_XXXXXX.sql)
trap 'docker exec jobmanager rm -f /tmp/flink_check.sql; rm -f "$SQL_FILE"' EXIT

cat > "$SQL_FILE" << 'FLINK_SQL'
SET sql-client.execution.result-mode=TABLEAU;

DROP TABLE IF EXISTS flink_datastream_api_sink;

CREATE TABLE flink_datastream_api_sink (
    `value` STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'my-flink-datastream-api-output',
    'properties.bootstrap.servers' = 'kafka:29092',
    'scan.startup.mode' = 'earliest-offset',
    'scan.bounded.mode' = 'latest-offset',
    'format' = 'raw'
);

SHOW TABLES;

SELECT * FROM flink_datastream_api_sink;
FLINK_SQL

docker cp "$SQL_FILE" jobmanager:/tmp/flink_check.sql
docker exec jobmanager ./bin/sql-client.sh -f /tmp/flink_check.sql
