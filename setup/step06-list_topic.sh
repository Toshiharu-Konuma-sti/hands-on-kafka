#!/bin/sh
set -e

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh
. ${CUR_DIR}/variables.sh

call_show_start_banner

echo "\n### START: Show the list of topics ##########"
docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --list

echo "\n### START: Show details of the partitioned topic ##########"
docker exec -it handson-client /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --describe --topic my-topic-partition

call_show_finish_banner
