FROM debian:buster

RUN apt-get update
RUN apt-get -y install nginx mariadb-server php-fpm php-mysql php-mbstring wget

COPY     srcs/default.conf /etc/nginx/sites-available/default
RUN 	openssl req -x509 -nodes -days 365 -subj "/C=PT/ST=./L=./O=./OU=./CN=." -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt