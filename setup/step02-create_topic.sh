#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

echo "\n### START: Create topics ##########"

docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-topic
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-ksql-input
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-flink-sql-input
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-flink-sql-output
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-flink-job-input
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-flink-job-output
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-schema-avro
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-plaintext-input
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-linesplit-output
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-pipe-output
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-wordcount-output
docker exec -it broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-myhandson-output

call_show_finish_banner
