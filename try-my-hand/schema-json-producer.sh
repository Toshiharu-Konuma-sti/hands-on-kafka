#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/variables.sh

${CUR_DIR}/confluent/bin/kafka-json-schema-console-producer \
  --bootstrap-server ${HOST_BROKER} \
  --topic my-stream-schema-json \
  --property schema.registry.url=http://${HOST_SCHEMA}/apis/ccompat/v7 \
  --property value.schema.id=1
