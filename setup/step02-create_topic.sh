#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

TRY_DIR=$(call_path_of_experience $CUR_DIR)
echo "### the dir for experiences = [$TRY_DIR] ##########"

echo "\n### START: Create topics ##########"

$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-topic
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-ksql-input
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-flink-sql-input
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-flink-sql-output
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-flink-job-input
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-flink-job-output
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-plaintext-input
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-linesplit-output
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-pipe-output
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-wordcount-output
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-stream-myhandson-output

call_show_finish_banner
