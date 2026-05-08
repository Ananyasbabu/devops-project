# #!/bin/bash

# # Ensure we can access the docker socket
# # We use 'sudo' only if it's available, otherwise we run directly
# if command -v sudo >/dev/null 2>&1; then
#     sudo chmod 666 /var/run/docker.sock || true
# else
#     chmod 666 /var/run/docker.sock || true
# fi
# #!/bin/bash


# # # Stop and remove existing container
# # docker stop devops-container || true
# # docker rm devops-container || true

# # # Build the new image from your Dockerfile
# # docker build -t devops-app:v1 .

# # # Run the new container
# # docker run -d -p 5000:5000 --name devops-container devops-app:v1

# #!/bin/bash

# # # 1. Build the image inside the Jenkins environment
# # docker build -t devops-app:v1 .

# # # 2. Apply the Kubernetes configuration
# # kubectl apply -f deployment.yaml

# # # 3. Force a refresh so it uses the newest build
# # kubectl rollout restart deployment/flask-app
# # # 1. Build the image
# # docker build -t devops-app:v1 .

# # # 2. Apply the YAML
# # kubectl apply -f deployment.yaml

# # # 3. The most important line for updates:
# # kubectl rollout restart deployment flask-app

# # 1. Build the specific v5 image
# docker build -t devops-app:v5 .

# # 2. Deploy to Kubernetes
# kubectl apply -f deployment.yaml

# # 3. Force the rollout so the new code goes live immediately
# kubectl rollout restart deployment flask-app

# # 4. Verify the status
# kubectl rollout status deployment flask-app


#!/bin/bash

# =================================================================
# DevOps Pipeline Deployment Script - Version 5
# Author: Ananya S. Babu (4NI23CS020)
# Purpose: Automate Build, Deploy, and Rollout for Kubernetes
# =================================================================

# 1. FIX PERMISSIONS
# Ensures Jenkins has access to the Docker engine via the socket
echo "Step 1: Setting Docker socket permissions..."
if command -v sudo >/dev/null 2>&1; then
    sudo chmod 666 /var/run/docker.sock || true
else
    chmod 666 /var/run/docker.sock || true
fi

# 2. BUILD IMAGE
# Builds the Docker image with the v5 tag
echo "Step 2: Building Docker image [devops-app:v5]..."
docker build -t devops-app:v5 .

# 3. APPLY KUBERNETES CONFIG
# Tells Kubernetes to update the cluster based on deployment.yaml
echo "Step 3: Applying Kubernetes configurations..."
kubectl apply -f deployment.yaml

# 4. FORCE ROLLOUT
# This is crucial: it forces Kubernetes to pull the new v5 image 
# and replace the old pods without any downtime.
echo "Step 4: Triggering rolling update for flask-app..."
kubectl rollout restart deployment flask-app

# 5. VERIFY STATUS
# The script will wait until all pods are successfully running.
echo "Step 5: Verifying deployment status..."
kubectl rollout status deployment flask-app

echo "Successfully deployed v5 to Kubernetes!"