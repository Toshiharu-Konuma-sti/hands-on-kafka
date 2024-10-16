#!/bin/sh

own_dir()
{
	ODIR=$(cd $(dirname $0); pwd)
	echo "$ODIR"
}

OWN_DIR=$(own_dir)
WRK_DIR=$OWN_DIR
echo "### work dir = [$WRK_DIR] ##########\n"

KAFKA_TGZ=kafka_2.13-3.8.0.tgz
KAFKA_PKG=$WRK_DIR/$KAFKA_TGZ
KAFKA_DIR=$WRK_DIR/kafka
BOOTSTRAP=localhost

echo "### START: Install JDK ##########"
java -version
if [ $? -ne 0 ]; then
	sudo apt install -y openjdk-8-jdk-headless
fi

echo "### START: Get CLI tool for Kafka ##########"

if [ ! -e $KAFKA_PKG ]; then
	wget https://ftp.riken.jp/net/apache/kafka/3.8.0/$KAFKA_TGZ
fi
if [ ! -d $KAFKA_DIR ]; then
	mkdir $KAFKA_DIR
fi
tar -zxvf $KAFKA_PKG -C $KAFKA_DIR --strip-components 1

echo "### START: Create topics ##########"

$WRK_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-topic
$WRK_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-ksql-input
$WRK_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-plaintext-input
$WRK_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-linesplit-output
$WRK_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-pipe-output
$WRK_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --create --topic my-streams-wordcount-output

echo "### START: Register KSQL streams ##########"

curl -v -X "POST" \
     -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
     -d @$WRK_DIR/ksql-create-stream-input.json \
     "http://localhost:8088/ksql"

curl -v -X "POST" \
     -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
     -d @$WRK_DIR/ksql-create-stream-output.json \
     "http://localhost:8088/ksql"

curl -v -X "POST" "http://localhost:8088/ksql" \
     -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
     -d '{"ksql": "SHOW STREAMS;", "streamsProperties": {}}' \
     "http://localhost:8088/ksql" | \
     jq

echo "### START: Register Connectors ##########"

curl -v -X POST \
     -H "Content-Type: application/json" \
     -d @$WRK_DIR/debezium.json \
     "http://$BOOTSTRAP:8083/connectors"

echo "\n### START: Show the list of topiscs ##########"

$WRK_DIR/kafka/bin/kafka-topics.sh --bootstrap-server $BOOTSTRAP:9092 --list

echo "### FINISH: Run the setup script ##########"

