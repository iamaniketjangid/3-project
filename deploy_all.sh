#!/bin/bash

echo "🚀 Starting Single-Click Deployment of 3 Apps + Kafka + Prometheus..."

# Step 1: Start Minikube
minikube start --driver=docker

# Step 2: Deploy Kafka
kubectl apply -f kafka.yaml
echo "Kafka pod deployed."

# Step 3: Build and run frontend
docker build -t app1-frontend ./app1-frontend
docker run -d -p 3000:3000 app1-frontend

# Step 4: Build and run backend
docker build -t app2-backend ./app2-backend
docker run -d -p 5000:5000 app2-backend

# Step 5: Run Mongo + Mongo-Express
docker build -t app3-db ./app3-db
docker run -d -p 8081:8081 app3-db

# Step 6: Install Prometheus (if not installed)
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus

# Step 7: Port-forward Prometheus
kubectl port-forward svc/prometheus-server 9090:80 &
echo "Prometheus port-forward running on http://localhost:9090"

echo "✅ All apps deployed successfully!"
