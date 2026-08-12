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
	echo "### the dir for setting up  = [${SET_DIR}] ##########"

	echo "\n### START: Register Connectors ##########"

	_cmd="curl -v -X POST
		\"http://$HOST_DEBEZIUM/connectors\"
		-H \"Content-Type: application/json\"
		-d \"@${SET_DIR}/config/debezium.json\""
	_body=$(loop_curl_until_success "${_cmd}")
	echo ${_body} | jq
}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
