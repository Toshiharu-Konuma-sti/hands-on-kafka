#!/bin/sh

S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)
. $CUR_DIR/functions.sh
. $CUR_DIR/extensions.sh

case "$1" in
	"up")
		clear
		start_banner
		finish_banner $S_TIME
		;;
	"down")
		clear
		start_banner
		destory_container $CUR_DIR
		show_list_container
		finish_banner $S_TIME
		;;
	"list")
		clear
		show_list_container
		;;
	"info")
		show_url
		;;
	"")
		clear
		start_banner
		destory_container $CUR_DIR
		create_container $CUR_DIR

		show_list_container
		show_url
		finish_banner $S_TIME
		;;
	*)
		show_usage
		exit 1
		;;

esac

