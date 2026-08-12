#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)

if ! docker inspect jobmanager > /dev/null 2>&1; then
  echo "[ERROR] jobmanager container is not running." >&2
  exit 1
fi

# install inside container only - host environment stays clean
docker exec jobmanager pip3 install --quiet kafka-python jsonschema requests 2>/dev/null
docker cp ${CUR_DIR}/schema-json-producer.py jobmanager:/tmp/schema-json-producer.py

docker exec -i jobmanager python3 /tmp/schema-json-producer.py \
  --bootstrap-server kafka:29092 \
  --topic my-stream-schema-json \
  --schema-registry-url http://schema-registry:8080/apis/ccompat/v7 \
  --schema-id 1
