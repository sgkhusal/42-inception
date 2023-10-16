FROM debian:bullseye

# disable "debconf: unable to initialize frontend: Dialog" message during build
ARG DEBIAN_FRONTEND=noninteractive

# fpm: fast process manager (php-fpm)
# --no-install-recommends
RUN apt update -y && apt install -y \
	procps \
	vim \
	php-fpm \
	php-mysql \
	mariadb-client \
	wget \
	&& apt clean && rm -rf /var/lib/apt/lists/*
	# > install_logs 2> install_errors_log
# to search:
# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
# debconf: delaying package configuration, since apt-utils is not installed

# set PHP-FPM listen location to port 9000 to comunicate with nginx container
# and enable getenv() on php files (to use in wp-config.php)
RUN echo "\nlisten = 0.0.0.0:9000" >> /etc/php/7.4/fpm/pool.d/www.conf && \
	echo "clear_env = no" >>/etc/php/7.4/fpm/pool.d/www.conf

# Create the directory where php-fpm will store the pid file
# and make an alias to call php-fpm without specifying the version
RUN mkdir -p /run/php \
	&& ln -s /usr/sbin/php-fpm7.4 /usr/bin/php-fpm

# working directory = where wordpress will be installed (volume)
WORKDIR /var/www/wordpress/

# download wp-cli
RUN wget \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp
# wp --info - check if is working

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
	sed -i "s/'database_name_here'/getenv('DB_WP_NAME')/g" wp-config.php && \
	sed -i "s/'username_here'/getenv('DB_USER')/g" wp-config.php && \
	sed -i "s/'password_here'/getenv('DB_USER_PASSWORD')/g" wp-config.php && \
	sed -i "s/localhost/mariadb/g" wp-config.php

COPY ./tools/wp-install.sh .
RUN chmod +x wp-install.sh \
	&& mv wp-install.sh /usr/bin/
# RUN ./wp-install.sh
# RUN rm wp-install.sh

EXPOSE 9000

STOPSIGNAL SIGQUIT

# -F: start php-fpm in foreground
ENTRYPOINT [ "wp-install.sh" ]
CMD ["php-fpm", "-F"]

# CMD [ "/usr/sbin/php-fpm7.4", "-F" ]
# CMD [ "sh", "-c", "sleep infinity" ]