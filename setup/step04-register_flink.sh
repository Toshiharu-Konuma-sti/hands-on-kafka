#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

SET_DIR=$(call_path_of_setup $CUR_DIR)
echo "### the dir for setting up  = [$SET_DIR] ##########"

echo "\n### START: Register Flink SQL Job ##########"

cat $SET_DIR/config/stream_flink.sql | docker exec -i jobmanager ./bin/sql-client.sh

call_show_finish_banner
