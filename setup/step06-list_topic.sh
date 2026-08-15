#!/bin/sh
set -e

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh
. ${CUR_DIR}/variables.sh

call_show_start_banner

echo "\n### START: Show the list of topics ##########"

docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --list

call_show_finish_banner
