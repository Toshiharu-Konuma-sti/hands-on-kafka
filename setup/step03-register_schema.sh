#!/bin/sh
set -e

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh
. ${CUR_DIR}/custom.sh
. ${CUR_DIR}/variables.sh

# {{{ main()
main()
{
	SET_DIR=$(call_path_of_setup $CUR_DIR)
	echo "### the dir for setting up  = [$SET_DIR] ##########"

	echo "\n### START: Register Schema Registory ##########"

	_payload=$(jq -c '{schemaType: "JSON", schema: tojson}' "${CUR_DIR}/config/schema_registry.json")
	echo ${_payload} | jq

	_cmd_schema="curl -v -X POST
		\"http://${HOST_SCHEMA}/apis/ccompat/v7/subjects/my-schema-json-value/versions\"
		-H \"Content-Type: application/vnd.schemaregistry.v1+json\"
		-d '${_payload}'"
	_body_schema=$(loop_curl_until_success "${_cmd_schema}")
}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
