#!/bin/bash

echo "Starting up cloud services..."
cd ..
docker-compose \
  -f ./docker-compose_config_server.yml \
  -f ./docker-compose_elk.yml \
  -f ./docker-compose_eureka.yml \
  -f ./docker-compose_event-service.yml \
  -f ./docker-compose_kafka.yml \
  -f ./docker-compose_keycloak.yml \
  -f ./docker-compose_metrics.yml \
  -f ./docker-compose_mongo.yml \
  -f ./docker-compose_postgres.yml \
  -f ./docker-compose_redis.yml \
  -f ./docker-compose_user-service.yml \
  -f ./docker-compose_web.yml  \
  -f ./docker-compose_zuul.yml \
up
