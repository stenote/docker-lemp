docker-nginx-php
===========

Based on [stenote/docker-lemp](https://github.com/stenote/docker-lemp)

# Usage

    docker run -d --name=lemp \
      -v local/path/to/www/:/var/www/ \
      -p external_port:80 \
      hauptj/docker-php