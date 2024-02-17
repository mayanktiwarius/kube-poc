#!/bin/bash
ansible-galaxy collection install kubernetes.core

echo "Uninstall nginx stateful set"
ansible-playbook deploy_nginx_statefulset.yml --tags absent_task
echo "Uninstall nginx deployment"
ansible-playbook deploy_nginx_deployment.yml --tags absent_task
echo "Uninstall nginx deployment: source of chaos"
ansible-playbook deploy_nginx_chaos_deployment.yml --tags absent_task