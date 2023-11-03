#!/bin/bash

docker-compose up -d

CONTAINER_ID=$(docker-compose ps -q fedora-app)

docker exec -it "$CONTAINER_ID" bash -c "dnf -y install bats && cd /app && bash"
 
docker-compose stop

