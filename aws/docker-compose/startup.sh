#!/bin/bash

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

echo "info: Starting up ELP dev cluster..."
docker-compose -f ./docker-compose_dev.yml up --remove-orphans &
