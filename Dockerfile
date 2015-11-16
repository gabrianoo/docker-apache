FROM ubuntu:14.04
MAINTAINER Ahmed Hassanien <ahmed_hassanien@otasys.com>

COPY 000-default-ssl.conf .

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get -q update && \
    apt-get -yq install apache2 && \
    a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod headers && \
    a2enmod rewrite && \
    a2enmod proxy_wstunnel && \
    a2enmod ssl && \
    mkdir /etc/apache2/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj "/" && \
    cat 000-default-ssl.conf | tee -a /etc/apache2/sites-available/000-default-ssl.conf && \
    a2ensite 000-default-ssl.conf && \
    rm 000-default-ssl.conf /etc/apache2/sites-available/default-ssl.conf && \
    service apache2 restart && \
    set -e && \
	rm -f /usr/local/apache2/logs/httpd.pid

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_PID_FILE=/var/run/apache2.pid \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_SERVERADMIN=admin@localhost \
    APACHE_SERVERNAME=localhost \
    APACHE_SERVERALIAS=docker.localhost \
    APACHE_DOCUMENTROOT=/var/www

# Expose the document root, sites and SSL certificates location
VOLUME ["/var/www", "/etc/apache2/sites-available", "/etc/apache2/ssl"]

EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/apache2", "-D", "NO_DETACH", "-D", "FOREGROUND"]
