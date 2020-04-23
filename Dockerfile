FROM php:7.4.5-apache

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug 

COPY  ./conf/php.ini /usr/local/etc/php/php.ini

# FIX PROBLEME WWW-DATA
RUN chown -R www-data:www-data /var/www/html

# BACKUP CONFIG
RUN mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak

# COPY NEW CONF
COPY ./conf/site.conf /etc/apache2/sites-available/000-default.conf
COPY ./conf/apache.conf /etc/apache2/apache2.conf

# CONF MOD
RUN a2enmod rewrite
RUN a2enmod rewrite
RUN a2enmod ssl

RUN service apache2 restart

# SSL CONF

RUN mkdir /etc/apache2/ssl

RUN openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj \
    "/C=FR/ST=FR/L=France/O=dev/CN=dev" \
    -keyout /home/ssl.key -out /home/ssl.crt

RUN cp /home/ssl.key /etc/apache2/ssl/ssl.key
RUN cp /home/ssl.crt /etc/apache2/ssl/ssl.crt
RUN mkdir -p /var/run/apache2/

RUN mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
COPY ./conf/ssl.conf /etc/apache2/sites-available/default-ssl.conf

RUN a2ensite default-ssl

RUN service apache2 restart


WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443