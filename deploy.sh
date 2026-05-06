#!/bin/bash

# Ensure we can access the docker socket
# We use 'sudo' only if it's available, otherwise we run directly
if command -v sudo >/dev/null 2>&1; then
    sudo chmod 666 /var/run/docker.sock || true
else
    chmod 666 /var/run/docker.sock || true
fi

# Stop and remove existing container
docker stop devops-container || true
docker rm devops-container || true

# Build the new image from your Dockerfile
docker build -t devops-app:v1 .

# Run the new container
docker run -d -p 5000:5000 --name devops-container devops-app:v1