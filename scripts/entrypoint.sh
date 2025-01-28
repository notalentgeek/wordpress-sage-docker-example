#!/bin/bash

# Check if WordPress setup has been done already
if [ ! -f /var/www/html/.wp-setup-done ]; then
  # Wait for MySQL to be ready
  until mysqladmin ping -h db --silent; do
    echo "Waiting for MySQL..."
    sleep 2
  done

  # Run WordPress config creation
  wp config create \
      --dbname=wordpress \
      --dbuser=wordpress \
      --dbpass=wordpress \
      --dbhost=db \
      --dbprefix=wp_ \
      --allow-root \
      --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

  # Install WordPress
  wp core install \
      --url="http://localhost:8080" \
      --title="Test Site~" \
      --admin_user="admin" \
      --admin_password="admin" \
      --admin_email="mikael.pratama@gmail.com" \
      --allow-root

  # Optional: Activate the theme if it exists
  wp theme activate hello-world-theme --allow-root

  # Install Acorn
  cd /var/www/html/wp-content/themes/hello-world-theme
  composer install
  # Load nvm and add npm to PATH
  export NVM_DIR="/root/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm install
  yes | wp acorn acorn:install --allow-root

  # Prevent File Permission Issue
  chown -R www-data:www-data /var/www/html/wp-content/
  chmod -R 775 /var/www/html/wp-content/cache/

  # Mark the setup as completed by creating a flag file
  touch /var/www/html/.wp-setup-done
fi

# Start PHP-FPM and Nginx (the main command)
echo "Starting services..."
service php8.3-fpm start
nginx -g 'daemon off;'
