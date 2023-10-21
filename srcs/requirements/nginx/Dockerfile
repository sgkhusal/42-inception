FROM debian:bullseye-slim

ARG CERT
ARG CERT_KEY
ARG WP_DOMAIN

RUN apt-get update -y && apt-get install -y \
	procps \
	vim \
	nginx \
	openssl \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN openssl req -batch -x509 -sha256 -nodes \
	-newkey rsa:2048 \
	-days 365 \
	-keyout $CERT_KEY \
	-out $CERT \
	-subj "/C=BR/ST=SP/L=SP/O=42/OU=sguilher/CN=$WP_DOMAIN"

COPY ./conf/nginx.conf /etc/nginx/sites-available
RUN sed -i "s#CERT_KEY#$CERT_KEY#" /etc/nginx/sites-available/nginx.conf && \
	sed -i "s#CERT#$CERT#" /etc/nginx/sites-available/nginx.conf && \
	sed -i "s#WP_DOMAIN#$WP_DOMAIN#" /etc/nginx/sites-available/nginx.conf && \
	ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf

EXPOSE 443

STOPSIGNAL SIGQUIT

ENTRYPOINT [ "nginx" ]
CMD [ "-g", "daemon off;" ]
