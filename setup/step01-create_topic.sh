#!/bin/sh
#	set -e

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh
. ${CUR_DIR}/variables.sh

# {{{ main()
main()
{
	echo "\n### START: Create topics ##########"

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-topic

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-flink-input
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-flink-sql-output
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-flink-table-api-output
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-pyflink-input
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-pyflink-output

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-schema-json

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-plaintext-input
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-linesplit-output
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-pipe-output
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-wordcount-output
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-myhandson-output

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-cdc-mysql.mytest.user
}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
