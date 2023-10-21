FROM debian:bullseye

# disable "debconf: unable to initialize frontend: Dialog" message during build
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y \
	procps \
	vim \
	php-fpm \
	php-mysql \
	mariadb-client \
	wget \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "\nlisten = 0.0.0.0:9000" >> /etc/php/7.4/fpm/pool.d/www.conf && \
	echo "clear_env = no" >>/etc/php/7.4/fpm/pool.d/www.conf
# 'clear_env = no' enables getenv() on php files (used in wp-config.php)

RUN mkdir -p /run/php \
	&& ln -s /usr/sbin/php-fpm7.4 /usr/bin/php-fpm

WORKDIR /var/www/wordpress/

RUN wget \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp
# wp --info - check if is working

# download Wordpress with wp-cli
RUN wp core download --path=/var/www/wordpress/ --allow-root --version=6.3.2

# Configure wordpress to use the database
RUN cp wp-config-sample.php wp-config.php && \
	sed -i "s/'database_name_here'/getenv('DB_WP_NAME')/g" wp-config.php && \
	sed -i "s/'username_here'/getenv('DB_USER')/g" wp-config.php && \
	sed -i "s/'password_here'/getenv('DB_USER_PASSWORD')/g" wp-config.php && \
	sed -i "s/localhost/mariadb/g" wp-config.php

COPY ./tools/wp-install.sh .
RUN chmod +x wp-install.sh \
	&& mv wp-install.sh /usr/bin/

EXPOSE 9000

STOPSIGNAL SIGQUIT

# -F: start php-fpm in foreground
ENTRYPOINT [ "wp-install.sh" ]
CMD ["php-fpm", "-F"]
