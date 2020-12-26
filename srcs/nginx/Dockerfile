FROM alpine:latest

#NGINX INSTALL AND LAUNCH
RUN apk add openrc --no-cache
RUN apk add acf-openssl
RUN apk update && apk upgrade
RUN apk add nginx

# NGINX CONF 
COPY nginx.conf /etc/nginx/nginx.conf  
COPY indexcp.html /var/lib/nginx/html/index.html 
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=IDF/L=Paris/O=42/CN=esoulard' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.pem
RUN mkdir -p /run/nginx

#SITES ACCESS 
RUN set -x \
	&& adduser -u 82 -D -S -G www-data www-data
RUN chown -R www-data:www-data /var/lib/nginx/html/ \
&& chmod -R 755 /var/lib/nginx/html/

#SSH
RUN apk update && apk add openssh \
&& rm -rf /var/cache/apk/*
COPY id_rsa /etc/ssh/ssh_host_rsa_key
COPY sshd_config /etc/ssh/
RUN chmod 600 -R /etc/ssh/ssh_host_*

#EXPOSE PORTS
EXPOSE 80 
EXPOSE 443
EXPOSE 400

COPY start.sh .
RUN chmod +x /start.sh

#RESTART
CMD ./start.sh