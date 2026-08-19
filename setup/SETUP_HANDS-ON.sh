#!/bin/sh
set -e

clear
S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh

start_banner

check_required_commands "jq"

${CUR_DIR}/step01-create_topic.sh
${CUR_DIR}/step02-register_flink.sh
${CUR_DIR}/step03-register_schema_registry.sh
${CUR_DIR}/step04-bind_stream_to_topic.sh
${CUR_DIR}/step05-register_connector.sh
${CUR_DIR}/step06-list_topic.sh

finish_banner ${S_TIME}
