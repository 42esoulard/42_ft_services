FROM alpine:latest

RUN apk upgrade && \
    printf '%s\n' \
      '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
      >> /etc/apk/repositories && \
    apk update && \
    apk add pure-ftpd@testing="1.0.49-r0" && \
    apk add openssl && \
    rm -rf /var/cache/apk/*

EXPOSE 21 21000

COPY startcp.sh start.sh
RUN chmod 755 start.sh
ENTRYPOINT ./start.sh