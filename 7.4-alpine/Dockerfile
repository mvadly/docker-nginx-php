FROM php:7.4-fpm-alpine

# Install system dependencies
RUN apk add --no-cache nginx supervisor bash libpng libpng-dev libjpeg-turbo-dev libwebp-dev libxpm-dev freetype-dev zip unzip git curl oniguruma-dev icu-dev libxml2-dev composer

# Install PHP extensions
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    --with-xpm \
    && docker-php-ext-install gd pdo pdo_mysql mbstring exif pcntl bcmath intl xml  

# Set working directory
WORKDIR /var/www/html

# Copy application code

# Install PHP dependencies
# RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy nginx config
COPY ./nginx.conf /etc/nginx/nginx.conf

# Copy supervisor config
COPY ./supervisord.conf /etc/supervisord.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose HTTP port
EXPOSE 80 443

# Start supervisord (which runs php-fpm and nginx)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]