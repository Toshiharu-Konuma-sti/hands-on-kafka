#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

SET_DIR=$(call_path_of_setup $CUR_DIR)
echo "### the dir for setting up  = [$SET_DIR] ##########"

echo "\n### START: Create topics ##########"
docker exec broker kafka-topics --bootstrap-server broker:29092 --delete --if-exists --topic my-stream-schema-json
docker exec broker kafka-topics --bootstrap-server broker:29092 --create --topic my-stream-schema-json
docker exec broker kafka-topics --bootstrap-server broker:29092 --list

echo "\n### START: Execute Flink Job ##########"
RAW_SCHEMA=$(jq -c . "$SET_DIR/config/stream_schema.json")
PAYLOAD=$(jq -n --arg st "JSON" --arg sc "$RAW_SCHEMA" '{schemaType: $st, schema: $sc}')

curl -X POST \
	-H "Content-Type: application/vnd.schemaregistry.v1+json" \
	-d "$PAYLOAD" \
	http://localhost:8081/subjects/my-stream-schema-test-value/versions

call_show_finish_banner
