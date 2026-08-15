#!/bin/sh
set -e

docker exec mysql mysql -u myuser -pmypass -D mytest -e "INSERT INTO user(name) VALUES ('taro sios');"
docker exec mysql mysql -u myuser -pmypass -D mytest -e "INSERT INTO user(name) VALUES ('hanako sios');"
docker exec mysql mysql -u myuser -pmypass -D mytest -e "UPDATE user SET name='taro2 sios2' WHERE id=1;"
