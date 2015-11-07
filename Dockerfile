FROM ubuntu:14.04
MAINTAINER Ahmed Hassanien <ahmed_hassanien@otasys.com>

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get -q update && \
    apt-get -yq install apache2 && \
    a2enmod proxy && \
    a2enmod proxy_http && \
    service apache2 restart

VOLUME ["/var/www", "/etc/apache2"]

EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
