# Install kube on workers
ansible-playbook -i ./inventory kube-worker-setup.yml

# Install kube on master
ansible-playbook -i ./inventory kube-master-setup.yml