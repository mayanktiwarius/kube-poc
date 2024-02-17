#!/bin/bash
set -x

echo "List existing policy"
pod_names=$(kubectl -n kube-system get pods -l k8s-app=cilium -o jsonpath='{.items[*].metadata.name}')

for pod in $pod_names; do
    echo "Policy for pod: $pod"
    kubectl -n kube-system exec $pod -- cilium-dbg endpoint list
done

echo "Apply policy"
curl https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/sw_l3_l4_l7_policy.yaml
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/sw_l3_l4_l7_policy.yaml



echo "Inspect updated policy"
pod_names=$(kubectl -n kube-system get pods -l k8s-app=cilium -o jsonpath='{.items[*].metadata.name}')

for pod in $pod_names; do
    echo "Policy for pod: $pod"
    kubectl -n kube-system exec $pod -- cilium-dbg endpoint list
done
kubectl describe ciliumnetworkpolicies