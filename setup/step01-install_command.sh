#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/variables.sh

call_show_start_banner

TRY_DIR=$(call_path_of_experience $CUR_DIR)
echo "### the dir for experiences = [$TRY_DIR] ##########"

KF_ARCHIVE="kafka_2.13-$KF_VER_NUM.tgz"
KF_BINARY_URL="https://downloads.apache.org/kafka/$KF_VER_NUM/$KF_ARCHIVE"
KF_BINARY_URL="https://ftp.riken.jp/net/apache/kafka/$KF_VER_NUM/$KF_ARCHIVE"
KF_DOWNLOADED=$TRY_DIR/$KF_ARCHIVE
KF_CLITOP_DIR=$TRY_DIR/kafka

CT_ARCHIVE="confluent-community-$CT_VER_NUM.0.tar.gz"
CT_BINARY_URL="https://packages.confluent.io/archive/$CT_VER_NUM/$CT_ARCHIVE"
CT_DOWNLOADED=$TRY_DIR/$CT_ARCHIVE
CT_CLITOP_DIR=$TRY_DIR/confluent

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

if [ ! -d $KF_CLITOP_DIR ] && [ ! -e $KF_DOWNLOADED ]; then
	echo "* url = [$KF_BINARY_URL]"
	wget -P $TRY_DIR $KF_BINARY_URL
fi
if [ ! -d $KF_CLITOP_DIR ]; then
	mkdir $KF_CLITOP_DIR
	tar -zxvf $KF_DOWNLOADED -C $KF_CLITOP_DIR --strip-components 1 && rm $KF_DOWNLOADED
fi

echo "\n### START: Get CLI tool for Confluent ##########"

if [ ! -d $CT_CLITOP_DIR ] && [ ! -e $CT_DOWNLOADED ]; then
	echo "* url = [$CT_BINARY_URL]"
	wget -P $TRY_DIR $CT_BINARY_URL
fi
if [ ! -d $CT_CLITOP_DIR ]; then
	mkdir $CT_CLITOP_DIR
	tar -zxvf $CT_DOWNLOADED -C $CT_CLITOP_DIR --strip-components 1 && rm $CT_DOWNLOADED
fi

call_show_finish_banner
