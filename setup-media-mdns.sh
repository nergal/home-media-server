#!/bin/bash

. .env

function _term {
  pkill -P $$
}

trap _term SIGTERM

for i in `cat SERVICES`; do
  avahi-publish -a $i.$DOMAIN -R $IP &
done

while true; do sleep 10000; done