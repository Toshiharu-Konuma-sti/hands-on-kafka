#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/variables.sh

if ! docker inspect handson-client > /dev/null 2>&1; then
  echo "[ERROR] handson-client container is not running." >&2
  exit 1
fi

docker cp ${CUR_DIR}/schema-json-consumer.py handson-client:/tmp/schema-json-consumer.py

docker exec -it handson-client python3 /tmp/schema-json-consumer.py \
  --bootstrap-server ${CONTAINER_BROKER} \
  --topic my-stream-schema-json \
  --schema-registry-url ${ENDPOINT_SCHEMA} \
  --from-beginning \
  --print-schema-ids
