FROM debian:bullseye

ARG DB_WP_NAME
ARG DB_ROOT
ARG DB_ROOT_PASSWORD
ARG DB_USER
ARG DB_USER_PASSWORD

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y \
	procps \
	vim \
	mariadb-server \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./conf/my.cnf .
RUN cat my.cnf >> /etc/mysql/my.cnf && rm my.cnf

RUN mkdir -p /run/mysqld \
    && chown mysql:mysql /run/mysqld/ \
    && chmod 770 /run/mysqld/

COPY ./tools/db-setup.sh .
RUN chmod +x ./db-setup.sh
RUN ./db-setup.sh

EXPOSE 3306

ENTRYPOINT [ "mysqld" ]