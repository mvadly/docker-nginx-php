# Menggunakan base image resmi Ubuntu
FROM ubuntu:18.04

# Mengatur variabel lingkungan
ENV DEBIAN_FRONTEND=noninteractive


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

RUN apt-get install curl -y && apt-get install telnet -y && apt-get install vim  -y && apt-get install nginx-extras -y && apt-get install redis-server -y

# Mengatur konfigurasi Nginx
COPY default /etc/nginx/sites-available/default

# Menyalakan PHP-FPM dan Nginx
RUN sed -i 's/listen = .*/listen = 9000/' /etc/php/7.2/fpm/pool.d/www.conf && \
    mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html

# Menyalakan Nginx di port 80
EXPOSE 80

# Menyalakan Nginx dan PHP-FPM ketika container dijalankan
CMD service redis-server start && service php7.2-fpm start && nginx -g "daemon off;"
