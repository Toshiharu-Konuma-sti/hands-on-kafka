
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
 * - Access the REST API endpoint with the following URL.
 *   - KSQL:            http://localhost:8088
 *   - Flink:           http://localhost:8183
 ***********************************************************/

EOS
}
# }}}

# {{{ show_usage()
show_usage()
{
	cat << EOS
Usage: $(basename $0) [options]

Start the containers needed for the hands-on. If there are any containers
already running, stop them and remove resources beforehand.

Options:
  up                    Start the containers.
  down                  Stop the containers and remove resources.
  list                  Show the list of containers.
  info                  Show the information such as URLs.

EOS
}
# }}}
