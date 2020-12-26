FROM alpine:3.4

#CP FILES
COPY start.sh .
COPY config.inc.php .

#PHP ADDS
RUN apk update && apk add php5-cli php5-mysql php5-mysqli php5-pdo_mysql wget openssl php5-ctype php5-xml php5-mcrypt php5-gd php5-pdo php5-zlib php5-openssl php5-curl php5-opcache php5-json

#REPO
RUN mkdir /www

#PHPMYADMIN INSTALL
RUN apk add wget \
&& wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz \
&& tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz \
&& mv phpMyAdmin-4.9.0.1-all-languages/* /www/ \
&& cp config.inc.php /www/

EXPOSE 5000

RUN chmod 755 ./start.sh
CMD ./start.sh