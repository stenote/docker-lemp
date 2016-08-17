#!/bin/bash

set -e

chown -R www-data:www-data /var/www /var/log/php

# init mysql db if necessary
if [ ! -d /var/lib/mysql/mysql ];then
    mysqld --initialize-insecure --user=root --datadir=/var/lib/mysql
fi

chown -R mysql:mysql /var/lib/mysql

exec /usr/bin/supervisord --nodaemon -c /etc/supervisor/supervisord.conf
