#!/bin/bash

set -e

chown -R www-data:www-data /var/www /var/log/php

# init mysql db if necessary
if [ ! -d /var/lib/mysql/mysql ];then
  mysql_install_db
fi

chown -R mysql:mysql /var/lib/mysql

exec /usr/bin/supervisord --nodaemon -c /etc/supervisor/supervisord.conf
