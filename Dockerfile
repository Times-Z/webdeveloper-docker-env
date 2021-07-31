# -------------------------
# CONF PHPMYADMIN CONTAINER
# -------------------------

FROM phpmyadmin/phpmyadmin

RUN rm /var/www/html/libraries/config.default.php

COPY ./conf/pma.php /var/www/html/libraries/config.default.php

# -------------------------
# CONF PHP CONTAINER
# -------------------------

FROM php:8.0.0-apache

# INSTALL XDEBUG AND PHP MYSQLI (deprecated)
RUN apt-get update && apt-get install -y libicu-dev libpq-dev

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug 


RUN docker-php-source extract \
    && docker-php-ext-install intl mysqli pgsql pdo_pgsql pdo_mysql \
    && docker-php-source delete

# INSTALL SYMFONY
RUN apt-get -y install wget
RUN wget https://get.symfony.com/cli/installer -O - | bash 
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# INSTALL COMPOSER
COPY ./conf/compose.sh ./compose.sh
RUN ./compose.sh
RUN rm ./compose.sh

# INSTALL MAILUTILS
RUN apt-get update && apt-get -y install apt-utils && apt-get -y install mailutils && apt-get install -y esmtp

# CONF MAIL
COPY ./conf/mail.conf /etc/esmtprc

RUN rm /usr/sbin/sendmail

RUN ln -s /usr/bin/esmtp /usr/sbin/sendmail

# CONF PHP INI
COPY  ./conf/php.ini /usr/local/etc/php/php.ini

# LOGS XDEBUG
RUN touch /usr/local/var/log/xdebug.log
RUN chmod 777 /usr/local/var/log/xdebug.log

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
EXPOSE 9000