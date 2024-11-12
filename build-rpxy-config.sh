#!/bin/sh

. .env

DOCKER_COMPOSE_FILE=./docker-compose.yml

echo "listen_port = 80\nlog_level = \"info\"\nlog_target = \"stdout\"\n"

for i in `cat SERVICES`; do
    SUBDOMAIN=`yq '.services."'"$i"'".container_name' $DOCKER_COMPOSE_FILE`
    PORT=`yq '.services."'"$i"'".ports[0]' $DOCKER_COMPOSE_FILE | cut -d':' -f1`

    if [ "$i" = "rpxy" ]; then
        continue
    fi

    echo "[apps.$i]\nserver_name = '$SUBDOMAIN.$DOMAIN'\nreverse_proxy = [{ upstream = [{ location = '$i:$PORT' }] }]\n"
done