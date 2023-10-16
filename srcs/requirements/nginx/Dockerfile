FROM debian:bullseye-slim

ARG CERT
ARG CERT_KEY
ARG WP_DOMAIN

RUN apt update -y && apt install -y \
	nginx \
	openssl \
	&& apt clean && rm -rf /var/lib/apt/lists/*

# Generate a self-signed ssl certificate for https
# openssl -req - certificate request and certificate generating command:
#              -batch Non-interactive mode
#              -x509 - outputs a certificate instead of a certificate request. This is typically used to generate test certificates
#              -nodes - This option is deprecated since OpenSSL 3.0; use -noenc instead.
#              -noenc - If this option is specified then if a private key is created it will not be encrypted.
#              -newkey arg - This option is used to generate a new private key unless -key is given.
#                      [rsa:]nbits generates an RSA key nbits in size. If nbits is omitted, i.e., -newkey rsa is specified, the default key size specified in the configuration file with the default_bits option is used if present, else 2048.
#              -days n - When -x509 is in use this specifies the number of days to certify the certificate for
#              -keyout filename - This gives the filename to write any private key to that has been newly created
#              -out filename - This specifies the output filename to write to or standard output by default
RUN openssl req -batch -x509 -sha256 -nodes \
	-newkey rsa:2048 \
	-days 365 \
	-keyout $CERT_KEY \
	-out $CERT \
	-subj "/C=BR/ST=SP/L=SP/O=42/OU=sguilher/CN=$WP_DOMAIN"

COPY ./conf/nginx.conf /etc/nginx/conf.d
# COPY ./conf/nginx.conf /etc/nginx/nginx.conf
# By default, the configuration file is named nginx.conf and placed in the
# directory /usr/local/nginx/conf, /etc/nginx, or /usr/local/etc/nginx
RUN sed -i "s#CERT_KEY#$CERT_KEY#" /etc/nginx/conf.d/nginx.conf && \
	sed -i "s#CERT#$CERT#" /etc/nginx/conf.d/nginx.conf && \
	sed -i "s#WP_DOMAIN#$WP_DOMAIN#" /etc/nginx/conf.d/nginx.conf

EXPOSE 443

STOPSIGNAL SIGQUIT

ENTRYPOINT [ "nginx" ]
CMD [ "-g", "daemon off;" ]

# - nginx docker image
# CMD ["nginx", "-g", "daemon off;"]