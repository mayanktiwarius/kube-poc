#!/bin/bash
set -x
echo "Installation of all pods"
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/http-sw-app.yaml

echo "List the pods and service"
kubectl get pods,svc

