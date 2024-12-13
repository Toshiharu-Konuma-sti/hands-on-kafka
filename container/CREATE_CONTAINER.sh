#!/bin/sh

clear
S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)

echo "############################################################"
echo "# START SCRIPT"
echo "############################################################"

echo "\n### START: Destory existing containers ##########"
docker-compose down

echo "\n### START: Create new containers ##########"
docker-compose up -d

echo "\n### START: Show a list of container ##########"
docker ps -a

cat << EOS

/************************************************************
 * Information:
 * - Access to Control Center for Confluent with the URL below. (It will take some time for booting it.)
 *   - http://localhost:9021/
 ***********************************************************/

EOS

E_TIME=$(date +%s)
DURATION=$((E_TIME - S_TIME))

echo "############################################################"
echo "# FINISH SCRIPT ($DURATION seconds)"
echo "############################################################"
