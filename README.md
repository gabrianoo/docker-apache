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
docker run -d --name docker-apache -p 80:80 443:443 docker-apache
```

### Checking everything is OK

Go to the docker engine URL [I assume it is localhost] `http://localhost`

## Versions

### Apache Latest

#### What is inside

1. Ubuntu 14.04
3. Apache Latest

#### How to run

```
docker run -d --name apache -p 80:80 otasys/apache
```
