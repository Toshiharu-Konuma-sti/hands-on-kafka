#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/variables.sh

docker exec -it handson-client ${KF_BIN}/kafka-console-consumer.sh \
 --bootstrap-server ${CONTAINER_BROKER} \
 --topic my-streams-linesplit-output \
 --formatter-property print.partition=true \
 --formatter-property print.offset=true \
 --formatter-property print.key=true \
 --from-beginning
