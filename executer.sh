#!/bin/bash

docker-compose up -d

CONTAINER_ID=$(docker-compose ps -q fedora-app)

docker exec -it "$CONTAINER_ID" bash -c "cd /app && bash"

docker-compose down

