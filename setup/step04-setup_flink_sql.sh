#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

SET_DIR=$(call_path_of_setup $CUR_DIR)
echo "### the dir for setting up  = [$SET_DIR] ##########"

echo "\n### START: Create topics ##########"
docker exec broker kafka-topics --bootstrap-server broker:29092 --delete --if-exists --topic my-stream-flink-sql-input
docker exec broker kafka-topics --bootstrap-server broker:29092 --delete --if-exists --topic my-stream-flink-sql-output
docker exec broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-flink-sql-input
docker exec broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-flink-sql-output
docker exec broker kafka-topics --bootstrap-server broker:29092 --list

echo "\n### START: Register Flink SQL ##########"
cat $SET_DIR/config/stream_flink.sql | docker exec -i jobmanager ./bin/sql-client.sh

call_show_finish_banner
