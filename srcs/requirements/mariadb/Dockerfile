FROM debian:bullseye
# FROM debian:bullseye-slim

ARG DB_WP_NAME
ARG DB_ROOT
ARG DB_ROOT_PASSWORD
ARG DB_USER
ARG DB_USER_PASSWORD

RUN apt update -y && apt install -y \
	procps \
	vim \
	mariadb-server \
	&& apt clean && rm -rf /var/lib/apt/lists/*

# copy configuration files
COPY ./conf/my.cnf .
RUN cat my.cnf >> /etc/mysql/my.cnf && rm my.cnf
# RUN echo "\n[mariadb]\nbind-address=0.0.0.0\nport=3306\n" >> /etc/mysql/my.cnf
# RUN echo "socket=/run/mysqld/mysqld.sock\n" >> /etc/mysql/my.cnf

# create the directory used for storing the MariaDB socket file, which enables
# local connections to the database server
RUN mkdir -p /run/mysqld \
    && chown mysql:mysql /run/mysqld/ \
    && chmod 770 /run/mysqld/

COPY ./tools/db-setup.sh .
RUN chmod +x ./db-setup.sh
RUN ./db-setup.sh
# RUN rm db-setup.sh

EXPOSE 3306

STOPSIGNAL SIGQUIT
# STOPSIGNAL SIGTERM

# ensure that db server starts with the necessary safety checks and configs
# and also with mariadb in foreground
# ENTRYPOINT [ "mysqld_safe" ]
CMD [ "mysqld_safe" ]
# CMD [ "mysqld" ]
# CMD [ "sh", "-c", "sleep infinity" ]