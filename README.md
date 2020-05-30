# Cloud Native Locator
_Quickstart guide for developer_



## Dependencies:
Project uses custom Keycloak image in order to handle user events via kafka message bus.
Custom Keycloak can be found at: [CloudNativeEventLocator](https://github.com/xcodeassociated/CloudNativeEventLocator)


## Build:
In order to build services docker images have to be built and tagged via `docker-compose build`

```bash
$ docker-compose -f ./docker-compose_elk.yml -f ./docker-compose_eureka.yml -f ./docker-compose_event-service.yml -f ./docker-compose_kafka.yml -f ./docker-compose_keycloak.yml -f ./docker-compose_metrics.yml -f ./docker-compose_mongo.yml -f ./docker-compose_postgres.yml -f ./docker-compose_redis.yml -f ./docker-compose_user-service.yml -f ./docker-compose_web.yml build --parallel
```

Linux only additional config:
```bash
$ sudo sysctl -w vm.max_map_count=262144
```

Sometimes it is required to clean up kafka volume directory:
```bash
$ rm -rf volumes/dev-kafka-*
```

## Run:
To run project use `docker-compose up` command

```bash
$ docker-compose -f ./docker-compose_elk.yml -f ./docker-compose_eureka.yml -f ./docker-compose_event-service.yml -f ./docker-compose_kafka.yml -f ./docker-compose_keycloak.yml -f ./docker-compose_metrics.yml -f ./docker-compose_mongo.yml -f ./docker-compose_postgres.yml -f ./docker-compose_redis.yml -f ./docker-compose_user-service.yml -f ./docker-compose_web.yml up
```
### Run without external tools web intgerfaces:
This setup is all that is equired (including own services) in order to run and host complete application without external service tools (e.g. MongoDB viewer or PostgreSQL PGadmin tools, ...)
```bash
$ docker-compose -f ./docker-compose_all-dev.yml up
```

## Development containers:
### Full external stack
In order to develop project the external dependencies can be launched:
```bash
$ docker-compose -f ./docker-compose_elk.yml -f ./docker-compose_kafka.yml -f ./docker-compose_keycloak.yml -f ./docker-compose_metrics.yml -f ./docker-compose_mongo.yml -f ./docker-compose_postgres.yml -f ./docker-compose_redis.yml up
```
_note_: ternal web tools are included in this mode, keep in mind that the JVM service has to launched separately  as well as `eureka` service

### Minimal external stack
This setup is used for minimal `dev` profile of the spring applications
```bash
$ docker-compose -f ./docker-compose_kafka.yml -f ./docker-compose_keycloak.yml -f ./docker-compose_mongo.yml -f ./docker-compose_postgres.yml -f ./docker-compose_redis.yml up
```
_note_: external web tools are included in this mode as well

### Generate self-sign certificate for ssl via `certbot`:
This step is required in order to enable _haproxy_ to use _ssl_ with _http mode_ to have fully functional `https://` protocol working

```bash
$ sudo certbot certonly --standalone
```

### Publish website:
In order to publish the website some proxy application has to be used e.g. _haproxy_, _nginx_, etc.
Haproxy config is ready to be used.
```bash
$ sudo haproxy -f ./haproxy/haproxy-lua.cfg
```

## Cleanup:
Docker containers clean up can be done via `docker-compose down` command

```bash
$ docker-compose -f ./docker-compose_elk.yml -f ./docker-compose_eureka.yml -f ./docker-compose_event-service.yml -f ./docker-compose_kafka.yml -f ./docker-compose_keycloak.yml -f ./docker-compose_metrics.yml -f ./docker-compose_mongo.yml -f ./docker-compose_postgres.yml -f ./docker-compose_redis.yml -f ./docker-compose_user-service.yml -f ./docker-compose_web.yml down
```
___

### Ecternal dependencies used:
1. **PostgreSQL** _essential_
2. **MongoDB** _essential_
3. **Kafka & Zookeeper** _essential_
4. **Redis** _essential_
5. **Grafana** & **InfluxDB**
6. ELK: **Elasticsearch**, **Logstash**, **Kibana**



### Author:
Feel free to **fork** or **contact me on github**:
[xcodeasscoaited](https://github.com/xcodeassociated) !
