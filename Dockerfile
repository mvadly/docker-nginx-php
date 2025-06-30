# Menggunakan base image resmi Ubuntu
FROM ubuntu:18.04

# Mengatur variabel lingkungan
ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Asia/Jakarta


WORKDIR /var/www/html

# Memperbarui package list dan menginstal dependensi
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y \
        nginx \
        php7.2 \
        php7.2-fpm \
        php7.2-cli \
        php7.2-mysql \
        php7.2-curl \
        php7.2-xml \
        php7.2-mbstring \
        php7.2-zip \
        php7.2-gd \
        php7.2-intl \
        php7.2-soap \
        php7.2-opcache && \
    apt-get clean

RUN apt-get install curl -y && apt-get install telnet -y && apt-get install vim -y && apt-get install wget -y
RUN apt-get install nginx-extras -y
RUN apt-get install php-redis -y

RUN wget https://github.com/elastic/apm-agent-php/releases/download/v1.10.0/apm-agent-php_1.10.0_all.deb  && dpkg -i apm-agent-php_1.10.0_all.deb


RUN echo "dockertest from image mvadly/nginx-php:7.2" > /about

# Mengatur konfigurasi Nginx
COPY default /etc/nginx/sites-available/default

# Menyalakan PHP-FPM dan Nginx
RUN sed -i 's/listen = .*/listen = 9000/' /etc/php/7.2/fpm/pool.d/www.conf && \
    mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
# Menyalakan Nginx di port 80
EXPOSE 443 80

# Menyalakan Nginx dan PHP-FPM ketika container dijalankan
CMD ["sh", "-c", "service php7.2-fpm start && nginx -g 'daemon off;'"]
