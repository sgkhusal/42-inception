FROM debian:bullseye

# wordpress requirements on the server side:
# PHP 7.4 or greater
# MySQL 5.7 or MariaDB 10.3 or greater
# HTTPS support

# Requirements on local:
# Login Account (user id and password) to the server via FTP or shell
# Text Editor
# FTP
# Your web browser of choice

# disable "debconf: unable to initialize frontend: Dialog" message during build
ARG DEBIAN_FRONTEND=noninteractive

# Fast process manager (php-fpm), php-mysql, mariadb-client and wget
# --no-install-recommends
RUN apt update -y && apt install -y \
	procps \
	vim \
	php-fpm \
	php-mysql \
	mariadb-client \
	wget \
	&& apt clean && rm -rf /var/lib/apt/lists/*
	# > install_logs 2> install_errors_log - parece não criar os arquivos...
# to search:
# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
# debconf: delaying package configuration, since apt-utils is not installed

# Replace the default PHP-FPM listen location (a local socket) with
# port 9000 to the wordpress container be able to communicate with nginx
RUN  echo "listen = 9000" >> /etc/php/7.4/fpm/pool.d/www.conf

# Create the directory where php-fpm will store the pid file
# and make alias to call php-fpm without specifying the version
RUN mkdir -p /run/php \
	&& ln -s /usr/sbin/php-fpm7.4 /usr/bin/php-fpm

# Set the working directory to where wordpress will be installed (volume)
WORKDIR /var/www/wordpress/

# install wp-cli and check if it is working
RUN wget \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp
# wp --info

# Download Wordpress with wp-cli
RUN wp core download --path=/var/www/wordpress/ --allow-root --version=6.3.2

# Download Wordpress (alternative)
# RUN wget https://wordpress.org/latest.tar.gz && \
# 	tar -xzf latest.tar.gz && \
# 	mv wordpress/* . && \
# 	rm -rf wordpress && \
# 	rm -rf latest.tar.gz

# Configure wordpress to use the database
RUN cp wp-config-sample.php wp-config.php && \
	sed -i "s/database_name_here/$DB_NAME/g" wp-config.php && \
	sed -i "s/username_here/$DB_USER/g" wp-config.php && \
	sed -i "s/password_here/$DB_USER_PASSWORD/g" wp-config.php && \
	sed -i "s/localhost/mariadb/g" wp-config.php

COPY ./tools/wp-install.sh .
RUN chmod +x ./wp-install.sh
# RUN ./wp-install.sh
# RUN rm wp-install.sh

# Install Wordpress with wp-cli
# RUN wp core install --allow-root --url=$WP_URL --title="Blog about kittens" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL

# create second user
# RUN wp user create --allow-root $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD

EXPOSE 9000

STOPSIGNAL SIGQUIT

# Start php-fpm in foreground
# CMD ["php-fpm", "-F"]
# CMD [ "/usr/sbin/php-fpm7.4", "-F" ]

CMD [ "sh", "-c", "sleep infinity" ]