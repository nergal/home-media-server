#!/bin/sh

echo "DOMAIN=$(hostname).local"
echo "UMASK=002"
echo "IP=$(hostname -I | cut -d' ' -f1)"
echo "PUID=$(id -u)"
echo "PGID=$(id -g)"
echo "TZ=$(cat /etc/timezone)"