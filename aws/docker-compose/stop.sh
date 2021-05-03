#!/bin/bash

is_user_root () { [ "$(id -u)" -eq 0 ]; }

if is_user_root; then
    echo "info: Rootcheck ok"
else
    echo "error: Run this script as root" >&2
    exit 1
fi

echo "info: Stopping the dev cluster"
docker-compose -f ./docker-compose_dev.yml down --remove-orphans

docker stop $(docker ps -a -q)
if [ $? -eq 0 ]; then
    echo "info: All docker processes stoped";
else
    echo "error: Could not stop all of docker processes";
    exit 1;
fi

rm -rf volumes/*
if [ $? -eq 0 ]; then
    echo "info: Removed volumes data";
else
    echo "error: Could not remove volumes data";
    exit 1;
fi

echo "info: Restarting/Starting haproxy..."
pkill -9 "haproxy";

echo "info: Stop finished"
exit 0;
