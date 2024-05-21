# Use an official PHP-Apache image as a base image
FROM php:8.1-apache

# Install necessary packages
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_mysql

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy the CodeIgniter application's source code to the container
COPY ./src /var/www/html

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the custom Apache configuration to the container
COPY build/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY build/composer.json /var/www/html/composer.json
# COPY composer.lock /var/www/html/composer.lock

RUN chown -R www-data:www-data /var/www/html/composer.*

# Here should use user: www-data
USER www-data:www-data

# Install Composer and project dependencies
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer update
RUN composer install

# Revert to root user to copy entrypoint script
USER root

# Copy entrypoint script
COPY build/entrypoint.sh /entrypoint.sh

# Add the opcache configuration
COPY build/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Copy custom php.ini
COPY build/php.ini /usr/local/etc/php/conf.d/php.ini

# Ensure the directory for OpCache file cache exists and has the right permissions
RUN mkdir -p /tmp/opcache && chown -R www-data:www-data /tmp/opcache

# Expose port 80 to the Docker host
EXPOSE 80

# Set the entrypoint to the custom script
ENTRYPOINT ["/entrypoint.sh"]