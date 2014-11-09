docker-lemp
===========

# Usage

    docker run -d --name=lemp \
      -v /path/to/www/:/var/www/ \
      -v /path/to/mysql:/var/lib/mysql \
      -p port_of_nginx:80 \
      -p port_of_sshd:22 \
      stenote/docker-lemp:latest

# Detail

## MySQL
* user: root
* password: 123456
  
## SSHD
* user: root
* password: 123456
