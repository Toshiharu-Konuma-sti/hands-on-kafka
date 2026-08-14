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

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-flink-input
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-flink-sql-output
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-flink-table-api-output
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-pyflink-input
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-pyflink-output

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-schema-json

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-plaintext-input
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-linesplit-output
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-pipe-output
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-wordcount-output
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-stream-myhandson-output

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-cdc-mysql.mytest.user
}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
