#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh
. ${CUR_DIR}/variables.sh

call_show_start_banner

echo "\n### START: Show the list of topics ##########"

docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --list

call_show_finish_banner
