#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

TRY_DIR=$(call_path_of_experience $CUR_DIR)
echo "### the dir for experiences = [$TRY_DIR] ##########"

echo "\n### START: Create topics ##########"

$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-topic
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-streams-ksql-input
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-streams-plaintext-input
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-streams-linesplit-output
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-streams-pipe-output
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-streams-wordcount-output
$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --create --topic my-streams-myhandson-output

call_show_finish_banner
