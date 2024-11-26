#!/bin/sh

clear
S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)

echo "############################################################"
echo "# START SCRIPT"
echo "############################################################"

$CUR_DIR/step01-install_command.sh
$CUR_DIR/step02-create_topic.sh
$CUR_DIR/step03-register_ksql.sh
$CUR_DIR/step04-register_connector.sh
$CUR_DIR/step05-bind_stream_to_topic.sh
$CUR_DIR/step06-list_topic.sh

E_TIME=$(date +%s)
DURATION=$((E_TIME - S_TIME))

echo "############################################################"
echo "# FINISH SCRIPT ($DURATION seconds)"
echo "############################################################"
