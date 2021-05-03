#!/bin/bash

is_user_root () { [ "$(id -u)" -eq 0 ]; }

init_mongodb () {
  echo "
  use test;
  db.test.insert({\"name\": \"test insert\"});
  db.createUser(
          {
              user: \"user\",
              pwd: \"user\",
              roles: [
                  {
                      role: \"readWrite\",
                      db: \"test\"
                  }
              ]
          }
  );

  rs.initiate();
  " | docker exec -i mongodb-cluster mongo
}

if is_user_root; then
    echo "info: Rootcheck ok"
else
    echo "error: Run this script as root" >&2
    exit 1
fi

echo "info: Starting up..."

echo "info: Turning down existing cluster..."
docker-compose -f ./docker-compose_dev.yml down

docker stop $(docker ps -a -q)
if [ $? -eq 0 ]; then
    echo "info: All docker processes stoped"
else
    echo "error: Could not stop all of docker processes"
fi

rm -rf volumes/*
if [ $? -eq 0 ]; then
    echo "info: Removed volumes data"
else
    echo "error: Could not remove kafka volumes"
fi


if pgrep -x "haproxy -f haproxy/haproxy.cfg" || pgrep -x "sudo haproxy -f haproxy/haproxy.cfg" > /dev/null
then
    echo "info: Haproxy is running, restarting..."
    pkill -9 "haproxy -f haproxy/haproxy.cfg"
    pkill -9 "sudo haproxy -f haproxy/haproxy.cfg"
else
    echo "info: Haproxy is not running"
fi

echo "info: Starting up haproxy..."
haproxy -f haproxy/haproxy.cfg &

echo "info: Starting up ELP dev cluster..."
docker-compose -f ./docker-compose_dev.yml up --remove-orphans &

sleep 5;

if init_mongodb | grep -q 'WriteCommandError'; then
   sleep 2;
   init_mongodb
fi

echo "info: Startup finished"
