FROM debian:bullseye

RUN mkdir -p /back

# Relative to the location of your Dockerfile,
# not your current working directory or the root of your project.
COPY ./ ngnix/

WORKDIR /ngnix