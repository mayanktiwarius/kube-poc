# kube-poc
POC of kube cluster

Once cluster is created.
Conenct to master
vagrant ssh master
Copy content of spec/deployment.yml file in master with name deployment.yml  and then create the nginx pod using commamd:
kubectl apply -f deployment.yml 

Link to access nginx: http://10.0.0.11:32000/

Vagrant cheatsheet:

Bring up the cluster:
vagrant up

Destroy the cluster:
vagrant destroy

Halt the cluster:
vagrant halt

Connect to master:
vagrant ssh master

Connecet to worker:
vagrant ssh node1
vagrant ssh node2


Kube installation:
connect to acm:
vagrant ssh acm
cd /vagrant/ansiblev2
ansible-playbook -i ./inventory/inventory.ini -e @/vagrant/settings.yaml kube-master-setup.yml

Pod installation:
$cd /vagrant/helm
$ansible-playbook deploy_nginx_statefulset.yml
$ansible-playbook deploy_nginx_deployment.yml


Troubleshoot:
1. kubeadm init not working due to stale data of last deployment.

Reset the kubeadm:
$vagrant ssh master
$sudo kubeadm reset

Sample init command to debug:
$sudo kubeadm init --apiserver-advertise-address=10.0.0.10 --apiserver-cert-extra-sans=10.0.0.10 --pod-network-cidr=172.16.1.0/16 --service-cidr=172.17.1.0/18 --node-name master-node --ignore-preflight-errors Swap

