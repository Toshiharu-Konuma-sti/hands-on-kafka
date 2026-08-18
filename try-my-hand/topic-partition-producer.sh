#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/variables.sh

docker exec -it handson-client ${KF_BIN}/kafka-console-producer.sh \
 --bootstrap-server ${CONTAINER_BROKER} \
 --topic my-topic-partition \
 --reader-property "parse.key=true" \
 --reader-property "key.separator=:"
