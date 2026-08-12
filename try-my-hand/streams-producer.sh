#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/variables.sh

${CUR_DIR}/kafka/bin/kafka-console-producer.sh --bootstrap-server ${HOST_BROKER} \
 --topic my-stream-plaintext-input
