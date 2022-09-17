FROM node:18-alpine3.16

# Install packages
RUN apk add --no-cache \
  curl \
  nano \
  nginx \
  php81 \
  php81-bcmath \
  php81-bz2 \
  php81-calendar \
  php81-ctype \
  php81-curl \
  php81-dba \
  php81-dom \
  php81-fpm \
  php81-enchant \
  php81-exif \
  php81-ffi \
  php81-fileinfo \
  php81-ftp \
  php81-gd \
  php81-gettext \
  php81-gmp \
  php81-iconv \
  php81-imap \
  php81-intl \
  php81-json \
  php81-ldap \
  php81-mbstring \
  php81-mysqli \
  php81-mysqlnd \
  php81-odbc \
  php81-opcache \
  php81-openssl \
  php81-pcntl \
  php81-pecl-imagick \
  php81-pdo \
  php81-pdo_dblib \
  php81-pdo_mysql \
  php81-pdo_odbc \
  php81-pdo_pgsql \
  php81-pdo_sqlite \
  php81-pgsql \
  php81-phar \
  php81-posix \
  php81-pspell \
  php81-redis \
  php81-session \
  php81-shmop \
  php81-simplexml \
  php81-snmp \
  php81-soap \
  php81-sockets \
  php81-sodium \
  php81-sqlite3 \
  php81-sysvmsg \
  php81-sysvsem \
  php81-sysvshm \
  php81-tidy \
  php81-tokenizer \
  php81-xml \
  php81-xmlreader \
  php81-xmlwriter \
  php81-xsl \
  php81-zip \
  php81-zlib \
  supervisor \
  wget

# Create symlink for php
RUN ln -s /usr/bin/php81 /usr/bin/php

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# nginx config files
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/default.conf /etc/nginx/sites-enabled/default.conf

# PHP-FPM config file
COPY config/fpm-pool.conf /etc/php81/php-fpm.d/www.conf

# supervisord config file
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# create root dirs required by npm and composer
RUN mkdir /.npm
RUN mkdir /.composer

# copy entrypoint script
COPY config/setup.sh /data/application/setup.sh

# document root
WORKDIR /project

# create user and set permissions
RUN adduser -D phplaravel
RUN chown -R phplaravel /project /run /var/lib/nginx /var/log/nginx /.npm /.composer

# switch user
USER phplaravel

# install laravel if workdir is empty
# start nginx & php-fpm
ENTRYPOINT ["/bin/sh", "-c", "/data/application/setup.sh"]
