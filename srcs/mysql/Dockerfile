FROM alpine:latest

RUN apk add --update mysql mysql-client \
&& rm -rf /var/cache/apk/*

COPY my.cnf /etc/mysql/my.cnf
COPY start.sh /start.sh

EXPOSE 3306

RUN chmod 755 /start.sh
CMD /start.sh