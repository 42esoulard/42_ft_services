FROM alpine:latest

COPY wordpress-5.3.2.tar.gz wordpress-5.3.2.tar.gz
COPY wp-config.php wp-config.php

RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session php-common php7-cli php7-common php7-json php7-opcache php-mbstring php-gd
#WORDPRESS INSTALL
RUN tar -zxvf wordpress-5.3.2.tar.gz
RUN mv wordpress/wp-config-sample.php wordpress/wp-config.php
RUN mkdir /www && mv wordpress/* /www \
&& mv wp-config.php /www/wp-config.php
RUN rm wordpress-5.3.2.tar.gz

EXPOSE 5050

CMD php -S 0.0.0.0:5050 -t /www/ 
