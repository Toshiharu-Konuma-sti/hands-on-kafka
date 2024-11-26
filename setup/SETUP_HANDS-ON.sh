#!/bin/sh

clear
S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)

echo "############################################################"
echo "# START SCRIPT"
echo "############################################################"

$CUR_DIR/step01-install_command.sh

###
###
###

own_dir()
{
	ODIR=$(cd $(dirname $0); pwd)
	echo "$ODIR"
}

SET_DIR=$(own_dir)
DOK_DIR=$(realpath $SET_DIR/../container)
EXP_DIR=$(realpath $SET_DIR/../try-my-hand)

#	ARCHIVE=kafka_2.13-3.8.0.tgz
#	BINARY_URL=https://downloads.apache.org/kafka/3.8.0/$ARCHIVE
#	BINARY_URL=https://ftp.riken.jp/net/apache/kafka/3.8.0/$ARCHIVE
#	DOWNLOADED=$EXP_DIR/$ARCHIVE
#	CLITOP_DIR=$EXP_DIR/kafka
BOOTSTRAP=localhost

echo "### the dir for container   = [$DOK_DIR] ##########"
echo "### the dir for setting up  = [$SET_DIR] ##########"
echo "### the dir for experiences = [$EXP_DIR] ##########\n"
#	if [ ! -d $EXP_DIR ]; then
#		mkdir $EXP_DIR
#	fi

#	echo "### START: Install JDK ##########"
#	java -version
#	if [ $? -ne 0 ]; then
#		sudo apt install -y openjdk-8-jdk-headless
#	fi

#	echo "### START: Get CLI tool for Kafka ##########"
#	if [ ! -e $DOWNLOADED ]; then
#		wget -P $EXP_DIR $BINARY_URL
#	fi
#	if [ ! -d $CLITOP_DIR ]; then
#		mkdir $CLITOP_DIR
#	fi
#	tar -zxvf $DOWNLOADED -C $CLITOP_DIR --strip-components 1

echo "### START: Create topics ##########"

$EXP_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-topic
$EXP_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-ksql-input
$EXP_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-plaintext-input
$EXP_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-linesplit-output
$EXP_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-pipe-output
$EXP_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-wordcount-output
$EXP_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-myhandson-output

echo "### START: Register KSQL streams ##########"

curl -v -X "POST" \
     "http://localhost:8088/ksql" \
     -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
     -d @$SET_DIR/ksql-create-stream-input.json

curl -v -X "POST" \
     "http://localhost:8088/ksql" \
     -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
     -d @$SET_DIR/ksql-create-stream-output.json

curl -v -X "POST" \
     "http://localhost:8088/ksql" \
     -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
     -d '{"ksql": "SHOW STREAMS;", "streamsProperties": {}}' | \
     jq

echo "### START: Register Connectors ##########"

curl -v -X POST \
     "http://$BOOTSTRAP:8083/connectors" \
     -H "Content-Type: application/json" \
     -d @$SET_DIR/debezium.json | \
     jq

echo "### START: Bind the topic with Streams Application after creating topics ##########"

docker-compose -f $DOK_DIR/docker-compose.yml restart streams

echo "\n### START: Show the list of topiscs ##########"

$EXP_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --list

echo "### FINISH: Run the setup script ##########"





E_TIME=$(date +%s)
DURATION=$((E_TIME - S_TIME))

echo "############################################################"
echo "# FINISH SCRIPT ($DURATION seconds)"
echo "############################################################"
