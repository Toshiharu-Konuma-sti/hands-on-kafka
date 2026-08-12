#!/bin/sh

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
	cat $SET_DIR/config/stream_flink.sql | docker exec -i jobmanager ./bin/sql-client.sh

	echo "\n### START: Execute Flink DataStream API (PyFlink) ##########"
	docker exec jobmanager ./bin/flink run -d --python /opt/flink/uppercase_users.py

#	echo "\n### START: Execute Flink DataStream API (PyFlink) ##########"
#	docker exec -it jobmanager ./bin/flink run --python /opt/flink/uppercase_users.py

}
# }}}

call_show_start_banner
main "$@"
call_show_finish_banner
