#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/variables.sh

docker exec -it handson-client ${KF_BIN}/kafka-console-consumer.sh \
 --bootstrap-server ${CONTAINER_BROKER} \
 --topic my-flink-table-api-output \
 --property print.partition=true \
 --property print.offset=true \
 --property print.key=true \
 --from-beginning
