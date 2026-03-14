#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

SET_DIR=$(call_path_of_setup $CUR_DIR)
echo "### the dir for setting up  = [$SET_DIR] ##########"

echo "\n### START: Create topics ##########"
docker exec broker kafka-topics --bootstrap-server broker:29092 --delete --if-exists --topic my-stream-pyflink-input
docker exec broker kafka-topics --bootstrap-server broker:29092 --delete --if-exists --topic my-stream-pyflink-output
docker exec broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-pyflink-input
docker exec broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-pyflink-output
docker exec broker kafka-topics --bootstrap-server broker:29092 --list

echo "\n### START: Execute PyFlink ##########"
docker exec -it jobmanager ./bin/flink run --python /opt/flink/uppercase_users.py

call_show_finish_banner
