#!/bin/bash
sudo apt update 
sudo apt install apache2 php libapache2-mod-php mariadb-server mariadb-client php-mysqlnd php-mysql php-curl php-xml php-mbstring php-imagick php-zip php-gd
cd /var/www/html
sudo wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
sudo tar -xzvf /tmp/wordpress.tar.gz
