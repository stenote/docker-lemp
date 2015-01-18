FROM ubuntu:14.04
MAINTAINER stenote stenote@163.com

ENV DEBIAN_FRONTEND noninteractive

#update
RUN apt-get update

# Install php nginx mysql supervisor
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
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php5\/cli.log/' /etc/php5/cli/php.ini
# nginx
RUN unlink /etc/nginx/sites-enabled/default
ADD nginx/default /etc/nginx/sites-enabled/default
ADD nginx/fastcgi_php /etc/nginx/fastcgi_php
# mysql
sed -i 's/^key_buffer\s*=/key_buffer_size =/' /etc/mysql/my.cnf
RUN /usr/sbin/mysqld --skip-networking & \
    sleep 5s && \
    echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '123456' WITH GRANT OPTION; FLUSH PRIVILEGES" \
    | mysql -u root -p123456
# supervisor
ADD supervisor/php5-fpm.conf /etc/supervisor/conf.d/php5-fpm.conf
ADD supervisor/nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD supervisor/mysql.conf /etc/supervisor/conf.d/mysql.conf

EXPOSE 80

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
