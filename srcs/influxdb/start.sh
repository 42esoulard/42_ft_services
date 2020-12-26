#!/bin/bash

CREATE_DB_QUERY="CREATE DATABASE $INFLUXDB_DB"

INIT_QUERY="CREATE USER \"$INFLUXDB_USER\" WITH PASSWORD '$INFLUXDB_PASSWORD' WITH ALL PRIVILEGES"

INFLUXDB_INIT_PORT="8086"

INFLUX_CMD="influx -host 127.0.0.1 -port $INFLUXDB_INIT_PORT -username ${INFLUXDB_ADMIN_USER} -password ${INFLUXDB_ADMIN_PASSWORD} -execute "
