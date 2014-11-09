FROM ubuntu:14.04
MAINTAINER stenote stenote@163.com

ENV DEBIAN_FRONTEND noninteractive

#update
RUN apt-get update

#Install Basic Packages
RUN apt-get install -y language-pack-en bash-completion

# Install Supervisor
RUN apt-get install -y supervisor && \
    sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

# Install PHP
RUN apt-get install -y php5-fpm php5-cli php5-gd php5-mcrypt php5-mysql php5-curl
RUN sed -i 's/^listen\s*=.*$/listen = 127.0.0.1:9000/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php5\/cgi.log/' /etc/php5/fpm/php.ini && \
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php5\/cli.log/' /etc/php5/cli/php.ini

ADD supervisor/php5-fpm.conf /etc/supervisor/conf.d/php5-fpm.conf

# Install Nginx
RUN apt-get install -y nginx && \
    echo 'daemon off;' >> /etc/nginx/nginx.conf && \
    unlink /etc/nginx/sites-enabled/default

ADD nginx/default /etc/nginx/sites-enabled/default

ADD nginx/fastcgi_php /etc/nginx/fastcgi_php

ADD supervisor/nginx.conf /etc/supervisor/conf.d/nginx.conf

# Install MySQL Server
RUN echo "mysql-server mysql-server/root_password password 123456" | debconf-set-selections && \
	echo "mysql-server mysql-server/root_password_again password 123456" | debconf-set-selections && \
	apt-get install -y mysql-server && \
	sed -i 's/^key_buffer\s*=/key_buffer_size =/' /etc/mysql/my.cnf

RUN /usr/sbin/mysqld --skip-networking & \
    sleep 5s && \
    echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '123456' WITH GRANT OPTION; FLUSH PRIVILEGES" \
    | mysql -u root -p123456

ADD supervisor/mysql.conf /etc/supervisor/conf.d/mysql.conf

# Install SSH Server
RUN apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo "root:123456" | chpasswd
RUN sed -i 's/^PermitRootLogin without-password$/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/#UsePAM no/' /etc/ssh/sshd_config

ADD supervisor/ssh.conf /etc/supervisor/conf.d/ssh.conf

# Install Development Tools
RUN apt-get install -y vim git

RUN apt-get clean

EXPOSE 22 80

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
