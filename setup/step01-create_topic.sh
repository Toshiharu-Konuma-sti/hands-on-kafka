#!/bin/sh
set -e

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh
. ${CUR_DIR}/variables.sh

# {{{ main()
main()
{
	echo "\n### START: Create topics ##########"

	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-topic
	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-flink-sql-input
	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-flink-sql-output
	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-pyflink-input
	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-pyflink-output
	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-schema-json

	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-plaintext-input
	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-linesplit-output
#	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-pipe-output
#	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-wordcount-output
	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-stream-myhandson-output

	docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:29092 --create --topic my-cdc-mysql.mytest.user
}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
