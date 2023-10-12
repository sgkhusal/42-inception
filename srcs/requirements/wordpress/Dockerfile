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
	wget
	# > install_logs 2> install_errors_log - parece não criar os arquivos...
# to search:
# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
# debconf: delaying package configuration, since apt-utils is not installed

# Replace the default PHP-FPM listen location (a local socket) with
# port 9000 to the wordpress container be able to communicate with nginx
RUN  echo "listen = 9000" >> /etc/php/7.4/fpm/pool.d/www.conf

# Set the working directory to where wordpress will be installed (volume)
WORKDIR /var/www/wordpress/

# Install Wordpress
RUN wget https://wordpress.org/latest.tar.gz && \
	tar -xzf latest.tar.gz && \
	mv wordpress/* . && \
	rm -rf wordpress && \
	rm -rf latest.tar.gz

# Configure wordpress to use the database
RUN cp wp-config-sample.php wp-config.php && \
	sed -i "s/database_name_here/$DB_NAME/g" wp-config.php && \
	sed -i "s/username_here/$DB_USER/g" wp-config.php && \
	sed -i "s/password_here/$DB_USER_PASSWORD/g" wp-config.php && \
	sed -i "s/localhost/mariadb/g" wp-config.php

# Create the directory where php-fpm will store the pid file
RUN mkdir -p /run/php

# An alias to call php-fpm without specifying the version on the CMD below
# RUN ln -s $(find /usr/sbin -name 'php-fpm*') /usr/bin/php-fpm

EXPOSE 9000

STOPSIGNAL SIGQUIT

# Start php-fpm in foreground
# CMD ["php-fpm", "-F"]
CMD [ "/usr/sbin/php-fpm7.4", "-F" ]

# CMD [ "sh", "-c", "sleep infinity" ]