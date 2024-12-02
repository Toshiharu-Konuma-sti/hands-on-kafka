#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

TRY_DIR=$(call_path_of_experience $CUR_DIR)
echo "### the dir for experiences = [$TRY_DIR] ##########"

ARCHIVE="kafka_2.13-$VER_NUM.tgz"
BINARY_URL="https://downloads.apache.org/kafka/$VER_NUM/$ARCHIVE"
BINARY_URL="https://ftp.riken.jp/net/apache/kafka/$VER_NUM/$ARCHIVE"
DOWNLOADED=$TRY_DIR/$ARCHIVE
CLITOP_DIR=$TRY_DIR/kafka
BOOTSTRAP=localhost

if [ ! -d $TRY_DIR ]; then
	mkdir $TRY_DIR
fi

echo "\n### START: Install JDK ##########"
java -version
if [ $? -ne 0 ]; then
	sudo apt install -y openjdk-8-jdk-headless
fi

echo "\n### START: Install Maven ##########"
mvn -version
if [ $? -ne 0 ]; then
	sudo apt install -y maven
fi

echo "\n### START: Get CLI tool for Kafka ##########"

if [ ! -d $CLITOP_DIR ] && [ ! -e $DOWNLOADED ]; then
	echo "* url = [$BINARY_URL]"
	wget -P $TRY_DIR $BINARY_URL
fi
if [ ! -d $CLITOP_DIR ]; then
	mkdir $CLITOP_DIR
	tar -zxvf $DOWNLOADED -C $CLITOP_DIR --strip-components 1 && rm $DOWNLOADED
fi

call_show_finish_banner
