# Menggunakan base image resmi Alpine
FROM alpine:3.12

# Mengatur variabel lingkungan
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/html

# Install Nginx and PHP extensions
RUN apk update && \
    apk add --no-cache nginx curl curl-dev busybox-extras vim libxml2-dev libpng-dev icu-dev \
    php php-fpm php-mysqli php-curl php-xml php-mbstring php-zip php-gd php-intl php-soap php-opcache

# Configure Nginx
COPY default /etc/nginx/http.d/default.conf

# Create /run/nginx directory for nginx.pid
RUN mkdir -p /run/nginx

# Configure PHP-FPM to listen on port 9000
RUN sed -i 's/^listen = .*/listen = 9000/' /etc/php7/php-fpm.d/www.conf

# Create www-data user and group for permissions (ignore if already exists)
RUN addgroup -S www-data || true && adduser -S -G www-data www-data || true

RUN mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html

# Menyalakan Nginx di port 80
EXPOSE 80
EXPOSE 8888

# Menyalakan Nginx dan PHP-FPM ketika container dijalankan
CMD php-fpm7 & nginx -g 'daemon off;'
