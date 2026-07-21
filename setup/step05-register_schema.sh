#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

# {{{ main()
main()
{
	SET_DIR=$(call_path_of_setup $CUR_DIR)
	echo "### the dir for setting up  = [$SET_DIR] ##########"

	echo "\n### START: Register Schema Registory ##########"

	_payload=$(jq -c '{schemaType: "JSON", schema: tojson}' "${CUR_DIR}/config/stream_schema.json")
	echo ${_payload} | jq

	curl -v -X POST \
		-H "Content-Type: application/vnd.schemaregistry.v1+json" \
		-d "${_payload}" \
		http://${HOST_SCHEMA}/subjects/my-stream-schema-json-value/versions
}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
