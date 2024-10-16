#!/bin/sh

own_dir()
{
	ODIR=$(cd $(dirname $0); pwd)
	echo "$ODIR"
}

OWN_DIR=$(own_dir)
echo "###[$OWN_DIR]###"

#	echo "\n146.75.112.215	repo.maven.apache.org" >> /etc/hosts

mvn clean -f $OWN_DIR/pom.xml
mvn package -f $OWN_DIR/pom.xml
mvn exec:java -Dexec.mainClass=jp.sios.apisl.handson.kafka.streams.Pipe -f $OWN_DIR/pom.xml
# mvn exec:java -Dexec.mainClass=jp.sios.apisl.handson.kafka.streams.LineSplit -f $OWN_DIR/pom.xml &
# mvn exec:java -Dexec.mainClass=jp.sios.apisl.handson.kafka.streams.WordCount -f $OWN_DIR/pom.xml &

