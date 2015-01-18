docker-lemp
===========

# Usage

    docker run -d --name=lemp \
      -v /path/to/www/:/var/www/ \
      -v /path/to/mysql:/var/lib/mysql \
      -p port_of_nginx:80 \
      stenote/docker-lemp:latest

# Detail

## MySQL
* user: root
* password: 123456

## SSH
We don't support SSH right now. You can use `docker exec` to enter the docker container.
