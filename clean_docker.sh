#!/bin/bash

# carefull, this script will delete all containers in your machine
# credits: wwwwelton

docker stop $(docker ps -a -q)
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -aq)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q)

docker system prune --volumes --all --force