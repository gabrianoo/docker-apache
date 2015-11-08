# Docker Apache

Docker build file for Team City server. You need to have [Docker](https://www.docker.com/) installed and running to make this useful.
Container is exposing default apache ports `80` and `443`.
This image is liekly to be used as a load balancer for another containers.

## Build from source

### How to build

```
git clone https://github.com/gabrianoo/docker-apache.git
docker build -t docker-apache docker-apache
```

### How to run

```
docker run -d --name docker-apache -p 80:80 -p 443:443 docker-apache
```

### Checking everything is OK

Go to the docker engine URL [I assume it is localhost] `http://localhost`

## Versions

### Apache Latest

#### What is inside

1. Ubuntu 14.04
3. Apache Latest (with mod_ssl, mod_proxy and mod_proxy_http enabled)

#### How to run

```
docker run -d --name apache -p 80:80 -p 443:443 otasys/apache
```

## Example of usage

##### Start the data container for teamcity [[Refer to docker teamcity for more details]](https://github.com/gabrianoo/docker-teamcity)
`docker run -d --name teamcity-data otasys/teamcity-data`

##### Start teamcity 9.1.3 container using the previous data container [[Refer to docker teamcity for more details]](https://github.com/gabrianoo/docker-teamcity)
`docker run -d --name teamcity --volumes-from teamcity-data otasys/teamcity:9.1.3`

##### Start apache as proxy
```
docker run -d --name apache -p 80:80 -p 443:443 --link teamcity:teamcity \
-v <PATH_TO_SITES_WITH_PROXY_CONF>:/etc/apache2/sites-available otasys/apache:2.4.7
```

##### Sample conf files

```
<VirtualHost *:80>
	DocumentRoot /var/www/html

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	ProxyPreserveHost On
	ProxyPass /tc http://teamcity:8111/tc
	ProxyPassReverse /tc http://teamcity:8111/tc
</VirtualHost>

```

```
<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        DocumentRoot /var/www/html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        
        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
        
        ProxyPreserveHost On
        ProxyPass /tc http://teamcity:8111/tc
        ProxyPassReverse /tc http://teamcity:8111/tc
    </VirtualHost>
</IfModule>
```