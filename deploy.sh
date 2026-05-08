#!/bin/bash

# Ensure we can access the docker socket
# We use 'sudo' only if it's available, otherwise we run directly
if command -v sudo >/dev/null 2>&1; then
    sudo chmod 666 /var/run/docker.sock || true
else
    chmod 666 /var/run/docker.sock || true
fi
#!/bin/bash


# # Stop and remove existing container
# docker stop devops-container || true
# docker rm devops-container || true

# # Build the new image from your Dockerfile
# docker build -t devops-app:v1 .

# # Run the new container
# docker run -d -p 5000:5000 --name devops-container devops-app:v1

#!/bin/bash

# # 1. Build the image inside the Jenkins environment
# docker build -t devops-app:v1 .

# # 2. Apply the Kubernetes configuration
# kubectl apply -f deployment.yaml

# # 3. Force a refresh so it uses the newest build
# kubectl rollout restart deployment/flask-app
# # 1. Build the image
# docker build -t devops-app:v1 .

# # 2. Apply the YAML
# kubectl apply -f deployment.yaml

# # 3. The most important line for updates:
# kubectl rollout restart deployment flask-app

# 1. Build the specific v5 image
docker build -t devops-app:v5 .

# 2. Deploy to Kubernetes
kubectl apply -f deployment.yaml

# 3. Force the rollout so the new code goes live immediately
kubectl rollout restart deployment flask-app

# 4. Verify the status
kubectl rollout status deployment flask-app