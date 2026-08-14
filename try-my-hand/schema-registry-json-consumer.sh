#!/bin/sh
set -e

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/variables.sh

MY_SCRIPT=schema-registry-json-consumer.py

docker cp ${CUR_DIR}/${MY_SCRIPT} handson-client:/tmp/${MY_SCRIPT}

docker exec -it handson-client python3 /tmp/${MY_SCRIPT} \
  --bootstrap-server ${CONTAINER_BROKER} \
  --topic my-schema-registry-json \
  --schema-registry-url ${ENDPOINT_SCHEMA} \
  --from-beginning \
  --print-schema-ids
