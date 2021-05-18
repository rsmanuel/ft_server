# Install base image (OS)
FROM debian:buster
# Update software packages in debian
RUN apt-get update
RUN apt-get upgrade -y
# Install nginx maria-db and php (wget to install .tar of wordpress and phpMyAdmin)
RUN apt-get -y install nginx mariadb-server php-mysql php-fpm php-pdo php-gd php-cli php-xml php-mbstring wget vim
# Replace the default nginx config file with all the configurations
COPY srcs/default.conf /etc/nginx/sites-available/default
# nginx will run in the foreground
RUN echo "daemon on;" >> /etc/nginx/nginx.conf
# remove index page
RUN rm var/www/html/index.nginx-debian.html
# generate ssl certificate (https)
RUN openssl req -x509 -nodes -days 365 -subj "/C=PT/ST=./L=./O=./OU=./CN=." -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt

#phpMyAdmin
#this is where the web server finds files for web pages  
WORKDIR /var/www/html/
#install phpMyAdmin using wget
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz
#extract tar file and remove .tar
RUN tar -xf phpMyAdmin-5.1.0-english.tar.gz && rm -rf phpMyAdmin-5.1.0-english.tar.gz
#then, change the name of the downloaded file
RUN mv phpMyAdmin-5.1.0-english phpmyadmin
#replace default phpMyAdmin config file
COPY srcs/config.inc.php /var/www/html/phpmyadmin

#wordpress
#install wordpress
RUN wget https://wordpress.org/latest.tar.gz
#extract tar file and remove .tar
RUN tar -xf latest.tar.gz && rm -rf latest.tar.gz
#replace wp config file
COPY srcs/wp-config.php /var/www/html/wordpress

# Give to user all the permissions
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*

# Copy and run the scripts to make the services start and config the MariaDB
WORKDIR /etc/nginx/sites-available/
COPY srcs/*.sh ./
CMD bash commands.sh
