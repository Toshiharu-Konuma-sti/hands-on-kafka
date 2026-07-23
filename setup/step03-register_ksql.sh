#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh
. ${CUR_DIR}/custom.sh
. ${CUR_DIR}/variables.sh

# {{{ main()
main()
{
	SET_DIR=$(call_path_of_setup $CUR_DIR)
	echo "### the dir for setting up  = [$SET_DIR] ##########"

	echo "\n### START: Register KSQL streams ##########"

	_cmd_ksql_i="curl -v -X POST
		\"http://${HOST_KSQLSVR}/ksql\"
		-H \"Content-Type: application/vnd.ksql.v1+json; charset=utf-8\"
		-d \"@$SET_DIR/config/stream_ksql_input.json\""
	_body_ksql_i=$(loop_curl_until_success "${_cmd_ksql_i}")

	_cmd_ksql_o="curl -v -X POST
		\"http://${HOST_KSQLSVR}/ksql\"
		-H \"Content-Type: application/vnd.ksql.v1+json; charset=utf-8\"
		-d \"@$SET_DIR/config/stream_ksql_output.json\""
	_body_ksql_o=$(loop_curl_until_success "${_cmd_ksql_o}")

	_cmd_ksql="curl -v -X POST
		\"http://${HOST_KSQLSVR}/ksql\"
		-H \"Content-Type: application/vnd.ksql.v1+json; charset=utf-8\"
		-d \"{\\\"ksql\\\": \\\"SHOW STREAMS;\\\", \\\"streamsProperties\\\": {}}\""
	_body_ksql=$(loop_curl_until_success "${_cmd_ksql}")
	echo ${_body_ksql} | jq
}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
