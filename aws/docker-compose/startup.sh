#!/bin/bash

is_user_root () { [ "$(id -u)" -eq 0 ]; }

if is_user_root; then
    echo "info: Rootcheck ok"
else
    echo "error: Run this script as root" >&2
    exit 1
fi

echo "info: Starting up..."

docker stop $(docker ps -a -q)
if [ $? -eq 0 ]; then
    echo "info: All docker processes stoped"
else
    echo "error: Could not stop all of docker processes"
fi

rm -rf volumes/dev-kafka-*
if [ $? -eq 0 ]; then
    echo "info: Removed kafka cluster volumes"
else
    echo "error: Could not remove kafka volumes"
fi

echo "info: Starting up haproxy..."
haproxy -f haproxy/haproxy.cfg &

echo "info: Starting up ELP dev cluster..."
docker-compose -f ./docker-compose_dev.yml up --remove-orphans &
