FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt install mariadb-server -y

# will be set in another place
ENV DB_NAME=inception
ENV DB_ROOT_PASSWORD=password
ENV DB_USER=user42
ENV DB_USER_PASSWORD=user42

# copy configuration files
COPY ./conf/mariadb.cnf /etc/mysql/mariadb.cnf
COPY ./conf/my.cnf ~/.my.cnf
# ~/.my.cnf is the last file readed for configs
# it overrides any previously defined option

COPY ./tools/db-setup.sh ./db-setup.sh
RUN chmod +x ./db-setup.sh
# RUN ./db-setup.sh

EXPOSE 3306

STOPSIGNAL SIGQUIT

# ensure that db server starts with the necessary safety checks and configs
# CMD [ "mysqld_safe" ]
CMD [ "sh", "-c", "sleep infinity" ]