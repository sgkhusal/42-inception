FROM debian:bullseye

RUN apt update -y && apt upgrade -y

# Fast process manager
RUN apt install php-fpm -y
RUN apt install wordpress -y

CMD [bash]