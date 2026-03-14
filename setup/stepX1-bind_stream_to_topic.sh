#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh

call_show_start_banner

DOK_DIR=$(call_path_of_container $CUR_DIR)
echo "### the dir for container   = [$DOK_DIR] ##########"

echo "### START: Bind the Streams Application to topic after creating topics ##########"
docker-compose -f $DOK_DIR/docker-compose.yml restart streams

call_show_finish_banner
