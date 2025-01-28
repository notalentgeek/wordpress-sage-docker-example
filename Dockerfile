FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install curl -y
RUN apt-get install git -y
RUN apt-get install mysql-client -y
RUN apt-get install nginx -y
RUN apt-get install php-fpm -y
RUN apt-get install php-mbstring -y
RUN apt-get install php-mysqli -y
RUN apt-get install php-xml -y
RUN apt-get install unzip -y

# Development Purpose Packages
RUN apt-get install iputils-ping -y

# Installing Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Installing NVM
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
    [ -s "$NVM_DIR/nvm.sh" ] && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 22

# Installing WP CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Installing WordPress
COPY wordpress-6.7.1.zip /tmp/
RUN mkdir -p /var/www/html
RUN unzip /tmp/wordpress-6.7.1.zip -d /tmp/
RUN mv /tmp/wordpress/* /var/www/html/
RUN rm -rf /tmp/wordpress /tmp/wordpress-6.7.1.zip
RUN chmod -R 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

RUN apt-get autoremove
RUN apt-get clean
WORKDIR /var/www/html
COPY nginx/default.conf /etc/nginx/sites-available/default
EXPOSE 80
CMD ["sh", "-c", "service php8.3-fpm start && nginx -g 'daemon off;'"]
