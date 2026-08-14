#!/bin/sh
set -e

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/common.sh
. ${CUR_DIR}/custom.sh
. ${CUR_DIR}/variables.sh

# {{{ main()
main()
{
	SET_DIR=$(call_path_of_setup $CUR_DIR)
	echo "### the dir for setting up  = [$SET_DIR] ##########"

	echo "\n### START: Cancel Existing Flink Jobs ##########"
	RUNNING_JOB_IDS=$(docker exec jobmanager ./bin/flink list 2>/dev/null | grep "RUNNING" | awk '{print $4}')
	if [ -n "$RUNNING_JOB_IDS" ]; then
		for JOB_ID in $RUNNING_JOB_IDS; do
			echo "Cancelling running Flink job: $JOB_ID"
			docker exec jobmanager ./bin/flink cancel "$JOB_ID"
		done
	else
		echo "No running Flink jobs found."
	fi

	echo "\n### START: Register Flink SQL ##########"
	cat $SET_DIR/config/flink_sql.sql | docker exec -i jobmanager ./bin/sql-client.sh

	echo "\n### START: Execute Flink Table API (PyFlink) ##########"
	docker exec jobmanager ./bin/flink run -d --python /opt/flink/table_api.py

	echo "\n### START: Execute Flink DataStream API (PyFlink) ##########"
	docker exec jobmanager ./bin/flink run -d --python /opt/flink/datastream_api.py

	echo "\n### START: Check Execute runing jobs ##########"
	sleep 3
	echo "docker exec jobmanager ./bin/flink list"
	docker exec jobmanager ./bin/flink list
}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
