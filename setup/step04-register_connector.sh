#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

SET_DIR=$(call_path_of_setup $CUR_DIR)
echo "### the dir for setting up  = [$SET_DIR] ##########"

echo "\n### START: Register Connectors ##########"

curl -v -X POST \
	"http://$HOST_DEBEZIUM/connectors" \
	-H "Content-Type: application/json" \
	-d @$SET_DIR/config/debezium.json | \
	jq

call_show_finish_banner
