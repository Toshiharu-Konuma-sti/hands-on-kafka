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
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-flink-datastream-api-output

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-schema-registry-json

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-streams-plaintext-input
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-streams-linesplit-output
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-streams-pipe-output
#	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-streams-wordcount-output
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-streams-myhandson-output

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-cdc-mysql.mytest.user

	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --create --topic my-topic-partition
	docker exec -it handson-client ${KF_BIN}/kafka-topics.sh --bootstrap-server ${CONTAINER_BROKER} --alter --topic my-topic-partition --partitions 3
}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
