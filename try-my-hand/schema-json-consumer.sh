#!/bin/sh
set -e

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/variables.sh

docker cp ${CUR_DIR}/schema-json-consumer.py handson-client:/tmp/schema-json-consumer.py

docker exec -it handson-client python3 /tmp/schema-json-consumer.py \
  --bootstrap-server ${CONTAINER_BROKER} \
  --topic my-stream-schema-json \
  --schema-registry-url ${ENDPOINT_SCHEMA} \
  --from-beginning \
  --print-schema-ids
