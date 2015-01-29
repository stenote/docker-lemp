docker-lemp
===========
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
