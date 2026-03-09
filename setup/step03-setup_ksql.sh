#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

SET_DIR=$(call_path_of_setup $CUR_DIR)
echo "### the dir for setting up  = [$SET_DIR] ##########"

echo "\n### START: Create topics ##########"
docker exec broker kafka-topics --bootstrap-server broker:29092 --delete --if-exists --topic my-stream-ksql-input
docker exec broker kafka-topics --bootstrap-server broker:29092 --delete --if-exists --topic my-stream-ksql-output
docker exec broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-ksql-input
docker exec broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-ksql-output
docker exec broker kafka-topics --bootstrap-server broker:29092 --list

echo "\n### START: Register KSQL streams ##########"
cat $SET_DIR/config/stream_ksql.sql | docker exec -i ksql-cli ksql http://ksql-server:8088

call_show_finish_banner

exit
