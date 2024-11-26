#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

TRY_DIR=$(call_path_of_experience $CUR_DIR)
echo "### the dir for experiences = [$TRY_DIR] ##########"

echo "\n### START: Show the list of topics ##########"

$TRY_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $HOST_BROKER --list

call_show_finish_banner
