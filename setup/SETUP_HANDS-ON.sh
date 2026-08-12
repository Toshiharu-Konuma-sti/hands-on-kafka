#!/bin/sh

clear
S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh

start_banner

${CUR_DIR}/step01-download_cli_command.sh
${CUR_DIR}/step02-create_topic.sh
${CUR_DIR}/step03-register_flink.sh
${CUR_DIR}/step04-register_schema.sh
${CUR_DIR}/step05-bind_stream_to_topic.sh
${CUR_DIR}/step06-register_connector.sh
${CUR_DIR}/step07-list_topic.sh

finish_banner ${S_TIME}
