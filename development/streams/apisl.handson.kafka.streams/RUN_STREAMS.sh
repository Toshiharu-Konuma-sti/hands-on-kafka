#!/bin/sh

own_dir()
{
	ODIR=$(cd $(dirname $0); pwd)
	echo "$ODIR"
}

OWN_DIR=$(own_dir)
echo "###[$OWN_DIR]###"

HOSTS="/etc/hosts"
REPO_DOMAIN="repo.maven.apache.org"

echo "### START: add repo domain to hosts ##########"

grep $REPO_DOMAIN $HOSTS
if [ $? -ne 0 ]; then
	echo "\n146.75.112.215	$REPO_DOMAIN" >> $HOSTS
	echo "completed to add the repo domain to hosts"
else
	echo "already added the repo domain"
fi

echo "### START: build and execute a stream application by maven ##########"

mvn clean package -f $OWN_DIR/pom.xml
# mvn exec:java -Dexec.mainClass=jp.sios.apisl.handson.kafka.streams.Pipe -f $OWN_DIR/pom.xml &
# mvn exec:java -Dexec.mainClass=jp.sios.apisl.handson.kafka.streams.LineSplit -f $OWN_DIR/pom.xml &
# mvn exec:java -Dexec.mainClass=jp.sios.apisl.handson.kafka.streams.WordCount -f $OWN_DIR/pom.xml &
mvn exec:java -Dexec.mainClass=jp.sios.apisl.handson.kafka.streams.MyHandsOn -f $OWN_DIR/pom.xml

