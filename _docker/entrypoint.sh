#!/bin/sh

# Fix storage permissions for mounted volumes
echo "Fixing storage permissions..."
chown -R www-data:www-data /var/www/storage 2>/dev/null || true
chmod -R 775 /var/www/storage 2>/dev/null || true

# Ensure log file exists with correct permissions
mkdir -p /var/www/storage/logs
touch /var/www/storage/logs/laravel.log
chown www-data:www-data /var/www/storage/logs/laravel.log 2>/dev/null || true
chmod 664 /var/www/storage/logs/laravel.log 2>/dev/null || true

echo "Starting PHP-FPM..."
# Start PHP-FPM directly (it will run as www-data from pool config)
exec php-fpm