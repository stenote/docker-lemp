docker-lemp
===========

[![Join the chat at https://gitter.im/docker-parasites/docker-lemp](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/docker-parasites/docker-lemp?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
We suppose this is a develop environment for phpers.

Don't use it in product environment.

# Usage

    docker run -d --name=lemp \
      -v /path/to/www/:/var/www/ \
      -v /path/to/mysql:/var/lib/mysql \
      -p port_of_nginx:80 \
      stenote/docker-lemp:latest

# Detail

## MySQL
* user: root
* (No password)

## SSH
We don't support SSH right now. You can use `docker exec` to enter the docker container.
