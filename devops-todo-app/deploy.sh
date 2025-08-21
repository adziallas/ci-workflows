#!/bin/bash
echo "🔄 Baue neue Docker-Images..."
docker-compose build

echo "📤 Push zu Docker Hub..."
docker tag devops-todo-app_frontend dein-dockerhub/frontend:latest
docker tag devops-todo-app_backend dein-dockerhub/backend:latest
docker push dein-dockerhub/frontend:latest
docker push dein-dockerhub/backend:latest

echo "🚀 Kubernetes Deployment aktualisieren..."
kubectl apply -f k8s/
