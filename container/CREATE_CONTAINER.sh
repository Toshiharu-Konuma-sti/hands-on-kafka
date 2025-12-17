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
 * - Navigate to Web ui tools with the URL below.
 *   - Control Center:  http://localhost:9021
 *   - Flink dashboard: http://localhost:8181
 ***********************************************************/

EOS

E_TIME=$(date +%s)
DURATION=$((E_TIME - S_TIME))

echo "############################################################"
echo "# FINISH SCRIPT ($DURATION seconds)"
echo "############################################################"
