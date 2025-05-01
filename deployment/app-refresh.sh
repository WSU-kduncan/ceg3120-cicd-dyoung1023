#!/bin/bash

IMAGE_NAME="dyoung1023/young-ceg3120:latest"
CONTAINER_NAME="angular-bird-app"

REPO_NAME=$1
TAG=$2

echo "[$(date)] Received push for repo: $REPO_NAME with tag: $TAG" >> /var/log/webhook-payload.log

docker pull $IMAGE_NAME

docker stop $CONTAINER_NAME 2>/dev/null

docker rm $CONTAINER_NAME 2>/dev/null

docker run -d -p 4200:4200 --name $CONTAINER_NAME $IMAGE_NAME

echo "Done. Container $CONTAINER_NAME should now be running the latest image."

