#!/bin/bash

export POD_NAME=$(kubectl get pods --namespace sre -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace sre port-forward $POD_NAME 9090 &


export POD_NAME=$(kubectl get pods --namespace sre -l "app.kubernetes.io/name=alertmanager,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace sre port-forward $POD_NAME 9093 &

export POD_NAME=$(kubectl get pods --namespace sre -l "app.kubernetes.io/instance=prometheus,app.kubernetes.io/name=prometheus-pushgateway" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace sre port-forward $POD_NAME 9091 &

export POD_NAME=$(kubectl get pods --namespace sre -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace sre port-forward $POD_NAME 3000 &