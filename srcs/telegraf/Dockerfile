FROM alpine:latest

COPY ./start.sh start.sh

RUN wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-1.13.4-static_linux_amd64.tar.gz.asc && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-1.13.4-static_linux_amd64.tar.gz && \
    mkdir -p /usr/src /etc/telegraf && \
    tar -C /usr/src -xzf telegraf-1.13.4-static_linux_amd64.tar.gz && \
    chmod +x /usr/src/telegraf*/* && \
    cp -a /usr/src/telegraf*/* /usr/bin/

RUN chmod 755 start.sh

CMD ./start.sh