FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt install mariadb-server -y

# # will be set in another place
# ENV DATABASE_NAME=inception
# # admin can't contain admin etc - it will have to be checked??
# ENV DB_ROOT_PASSWORD=password
# ENV DB_USER=user42
# ENV DB_USER_PASSWORD=user42
# # RUN mysql_secure_installation

# copy configuration files
COPY ./conf/mariadb.cnf /etc/mysql/mariadb.cnf
COPY ./conf/my.cnf ~/.my.cnf
# ~/.my.cnf is the last file readed for configs
# it overrides any previously defined option

# COPY ./tools/db-setup.sh ./db-setup.sh
# RUN chmod +x ./db-setup.sh

EXPOSE 3306

STOPSIGNAL SIGQUIT

# RUN service mariadb start
# CMD [ "./db-setup.sh" ]
CMD [ "sh", "-c", "sleep infinity" ]