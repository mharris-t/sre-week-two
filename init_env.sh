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

export POD_NAME=$(kubectl get pods --namespace sre -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace sre port-forward $POD_NAME 9090 &


export POD_NAME=$(kubectl get pods --namespace sre -l "app.kubernetes.io/name=alertmanager,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace sre port-forward $POD_NAME 9093 &

export POD_NAME=$(kubectl get pods --namespace sre -l "app.kubernetes.io/instance=prometheus,app.kubernetes.io/name=prometheus-pushgateway" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace sre port-forward $POD_NAME 9091 &

export POD_NAME=$(kubectl get pods --namespace sre -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace sre port-forward $POD_NAME 3000 &

kubectl apply -f deployment.yml -n sre
kubectl apply -f service.yml -n sre

kubectl get deployment -n sre

