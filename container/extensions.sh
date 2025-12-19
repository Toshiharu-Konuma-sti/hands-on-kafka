
# {{{ create_container()
# $1: the current directory
create_container()
{
	CUR_DIR=$1
	echo "\n### START: Create new containers ##########"
#	docker volume create --name=artifactory_data
#	docker volume create --name=postgres_data
#	docker volume create --name=dtrack-data
#	docker volume create --name=postgres-data
	docker-compose \
		-f $CUR_DIR/docker-compose.yml \
		up -d -V --remove-orphans
}
# }}}

# {{{ destory_container()
# $1: the current directory
destory_container()
{
	CUR_DIR=$1
	echo "\n### START: Destory existing containers ##########"
	docker-compose \
		-f $CUR_DIR/docker-compose.yml \
		down -v --remove-orphans
#	docker volume rm artifactory_data
#	docker volume rm postgres_data
#	docker volume rm dtrack-data
#	docker volume rm postgres-data
}
# }}}

# {{{ show_url()
show_url()
{
	cat << EOS

/************************************************************
 * Information:
 * - Navigate to Web ui tools with the URL below.
 *   - Control Center:  http://localhost:9021
 *   - Flink dashboard: http://localhost:8181
 ***********************************************************/
EOS
}
# }}}
