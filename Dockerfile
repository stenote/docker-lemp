FROM debian:latest
MAINTAINER stenote stenote@163.com

ENV DEBIAN_FRONTEND noninteractive

# Use free software totally, so there is no 'contrib' and 'non-free' here.
RUN echo "deb http://mirrors.sohu.com/debian wheezy main\n\
deb http://mirrors.sohu.com/debian wheezy-updates main\n\
" > /etc/apt/sources.list

## Install php nginx mysql supervisor
RUN apt-get update && \
    apt-get install -y php5-fpm php5-cli php5-gd php5-mcrypt php5-mysql php5-curl \
                       nginx \
		       supervisor && \
    echo "mysql-server mysql-server/root_password password 123456" | debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password 123456" | debconf-set-selections && \
    apt-get install -y mysql-server && \
    rm -rf /var/lib/apt/lists/*

## Configuration
# php-fpm
RUN sed -i 's/^listen\s*=.*$/listen = 127.0.0.1:9000/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php5\/cgi.log/' /etc/php5/fpm/php.ini && \
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php5\/cli.log/' /etc/php5/cli/php.ini && \
    mkdir /var/log/php5/ && \
    touch /var/log/php5/cli.log /var/log/php5/cgi.log && \
    chown www-data:www-data /var/log/php5/cgi.log /var/log/php5/cli.log

# nginx
RUN unlink /etc/nginx/sites-enabled/default
ADD nginx/default /etc/nginx/sites-enabled/default
ADD nginx/fastcgi_php /etc/nginx/fastcgi_php
RUN mkdir /var/www/ && chown -R www-data:www-data /var/www/
# mysql
sed -i 's/^key_buffer\s*=/key_buffer_size =/' /etc/mysql/my.cnf
RUN /usr/sbin/mysqld --skip-networking & \
    sleep 5s && \
    echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '123456' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql -u root -p123456 && \
    chown -R mysql:mysql /var/lib/mysql

# supervisor
ADD supervisor/php5-fpm.conf /etc/supervisor/conf.d/php5-fpm.conf
ADD supervisor/nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD supervisor/mysql.conf /etc/supervisor/conf.d/mysql.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisord.conf"]
