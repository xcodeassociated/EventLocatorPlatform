#!/bin/bash

is_user_root () { [ "$(id -u)" -eq 0 ]; }

init_mongodb () {
  echo "
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
  " | docker exec -i mongodb-cluster mongo;
}

init_event_categories () {
  echo "
  db.eventCategoryDocument.insert(
  {
    \"_id\" : ObjectId(\"5f82e229de878118265be485\"),
    \"title\" : \"TestCategoryA\",
    \"description\" : \"TestCategoryA description\",
    \"uuid\" : \"89fe4506-8519-4c33-8d6f-400c8c65807e\",
    \"createdDate\" : NumberLong(1602413097048),
    \"lastModifiedDate\" : NumberLong(1602426708373),
    \"createdBy\" : \"5b63b4b5-f040-4d99-851b-3e91494b8dcf\",
    \"modifiedBy\" : \"5b63b4b5-f040-4d99-851b-3e91494b8dcf\",
    \"version\" : NumberLong(1),
    \"_class\" : \"com.xcodeassociated.service.model.db.EventCategoryDocument\"
  });

  db.eventCategoryDocument.insert(
  {
    \"_id\" : ObjectId(\"5f831e9dbd645655fdd47085\"),
    \"title\" : \"TestCategoryB\",
    \"description\" : \"TestCategoryB description\",
    \"uuid\" : \"bf4ea6a5-56f6-44b8-b2f3-ea93465148f4\",
    \"createdDate\" : NumberLong(1602428573163),
    \"lastModifiedDate\" : NumberLong(1602428573163),
    \"createdBy\" : \"5b63b4b5-f040-4d99-851b-3e91494b8dcf\",
    \"modifiedBy\" : \"5b63b4b5-f040-4d99-851b-3e91494b8dcf\",
    \"version\" : NumberLong(0),
    \"_class\" : \"com.xcodeassociated.service.model.db.EventCategoryDocument\"
  });
  " | docker exec -i mongodb-cluster mongo;
}

if is_user_root; then
    echo "info: Rootcheck ok";
else
    echo "error: Run this script as root" >&2;
    exit 1;
fi

if [ $# -eq 0 ]; then
  echo "error: Please pass PATH as argument";
  exit 1;
else
  echo "info: Using PATH: $1"
fi

pwd=$1

echo "info: Going into: $pwd"
cd $pwd

echo "info: Starting up...";

echo "info: Turning down existing cluster...";
docker-compose -f "./docker-compose_dev.yml" down --remove-orphans

docker stop $(docker ps -a -q)
if [ $? -eq 0 ]; then
    echo "info: All docker processes stoped";
else
    echo "error: Could not stop all of docker processes";
    exit 1;
fi

rm -rf "volumes/*"
if [ $? -eq 0 ]; then
    echo "info: Removed volumes data";
else
    echo "error: Could not remove volumes data";
    exit 1;
fi

sleep 5;

echo "info: Restarting/Starting haproxy..."
pkill -9 "haproxy";
/usr/sbin/haproxy -f "haproxy/haproxy.cfg" &

echo "info: Starting up ELP dev cluster..."
docker-compose -f "./docker-compose_dev.yml" up --remove-orphans &

sleep 10;

if init_mongodb | grep -q 'WriteCommandError'; then
   sleep 2;
   init_mongodb;
fi

sleep 5;

echo "info: Init event categories..."
if init_event_categories | grep -qi "inserted"; then
  echo "info: Insert success";
else
  echo "error: Could not insert init mongo data";
  exit 1;
fi

echo "info: Startup finished";
exit 0;
