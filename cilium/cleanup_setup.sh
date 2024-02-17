#!/bin/bash
set -x
kubectl delete -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/http-sw-app.yaml
kubectl delete cnp rule1