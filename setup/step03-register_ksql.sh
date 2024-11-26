#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

SET_DIR=$(call_path_of_setup $CUR_DIR)
echo "### the dir for setting up  = [$SET_DIR] ##########"

echo "\n### START: Register KSQL streams ##########"

curl -v -X "POST" \
	"http://$HOST_KSQLSVR/ksql" \
	-H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
	-d @$SET_DIR/config/ksql-create-stream-input.json

curl -v -X "POST" \
	"http://$HOST_KSQLSVR/ksql" \
	-H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
	-d @$SET_DIR/config/ksql-create-stream-output.json

curl -v -X "POST" \
	"http://$HOST_KSQLSVR/ksql" \
	-H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
	-d '{"ksql": "SHOW STREAMS;", "streamsProperties": {}}' | \
	jq

call_show_finish_banner
