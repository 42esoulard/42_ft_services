FROM alpine:latest

RUN wget --no-verbose https://dl.influxdata.com/influxdb/releases/influxdb-1.7.10-static_linux_amd64.tar.gz.asc
RUN wget --no-verbose https://dl.influxdata.com/influxdb/releases/influxdb-1.7.10-static_linux_amd64.tar.gz
RUN mkdir -p /usr/src
RUN tar -C /usr/src -xzf influxdb-1.7.10-static_linux_amd64.tar.gz
RUN rm -f /usr/src/influxdb-*/influxdb.conf
RUN chmod +x /usr/src/influxdb*/*
RUN cp -a /usr/src/influxdb-*/* /usr/bin/

COPY influxdb.conf /etc/influxdb/influxdb.conf

COPY ./start.sh start.sh
RUN chmod 755 start.sh

EXPOSE 8086

CMD sh start.sh
CMD influxd