#!/usr/bin/env sh

# install laravel if project directory is empty
if [ -z "$(ls -A /project)" ]
then
   composer create-project laravel/laravel:^9 .
fi

# start nginx & php-fpm
supervisord -c /etc/supervisor/conf.d/supervisord.conf;
