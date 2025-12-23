# Base: Alpine Linux
FROM alpine:3.18

# Install dependencies: PHP, Nginx, Supervisor, Composer
RUN apk add --no-cache \
    php81 \
    php81-fpm \
    php81-cli \
    php81-mbstring \
    php81-opcache \
    php81-curl \
    php81-xml \
    php81-zip \
    php81-gd \
    php81-intl \
    php81-pdo \
    php81-pdo_mysql \
    php81-tokenizer \
    nginx \
    supervisor \
    curl \
    git \
    bash \
    composer

# Configure Nginx
RUN mkdir -p /run/nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY php-fpm.conf /etc/php81/php-fpm.conf

# Configure Supervisor to run both Nginx and PHP-FPM
COPY supervisord.conf /etc/supervisord.conf

# Set working directory
WORKDIR /app

# Expose HTTP port
EXPOSE 80

# Start Supervisor (manages Nginx + PHP-FPM)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
