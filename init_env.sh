#!/bin/bash

echo 'Staring Minikube...\n'
minikube start

echo 'Creating sre K8s namespace...\n'
kubectl create namespace sre

echo 'Installing Prometheus...\n'
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus -f prometheus.yml --namespace sre

echo 'Installing Grafana...\n'
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana --namespace sre --set adminPassword="admin"

kubectl apply -f deployment.yml -n sre
kubectl apply -f service.yml -n sre

kubectl get deployment -n sre

