#!/bin/bash
set -x
echo "List the pods and service before bringing up"
kubectl get pods,svc --all-namespaces -o wide

echo "Installation of all pods"
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/http-sw-app.yaml

echo "Waiting for 1 min for pods to come up"
sleep 60

echo "List the pods and service after bringing up"
kubectl get pods,svc --all-namespaces -o wide

