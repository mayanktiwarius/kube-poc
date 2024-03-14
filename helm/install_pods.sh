#!/bin/bash
ansible-galaxy collection install kubernetes.core

echo "Install nginx stateful set"
ansible-playbook deploy_nginx_statefulset.yml
echo "Install nginx deployment"
ansible-playbook deploy_nginx_deployment.yml
echo "Install nginx deployment: source of chaos"
ansible-playbook deploy_nginx_chaos_deployment.yml