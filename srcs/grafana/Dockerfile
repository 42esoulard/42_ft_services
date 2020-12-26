FROM alpine:latest

RUN wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-5.0.4.linux-x64.tar.gz
RUN tar -zxvf grafana-5.0.4.linux-x64.tar.gz \
&& mv grafana-5.0.4 grafana \
&& rm grafana-5.0.4.linux-x64.tar.gz
RUN apk --no-cache add curl

#ADDING GLIBC
RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk
RUN apk add glibc-2.28-r0.apk \
&& rm -rf /var/cache/apk/*

RUN cp grafana/bin/* usr/bin/

EXPOSE 3000

CMD cd grafana && \
grafana-server
