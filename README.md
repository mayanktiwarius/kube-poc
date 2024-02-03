# kube-poc
### POC of kube cluster

- Create the VM cluster
```
$cd kube-poc
$vagrant up
```


# Kube installation:
- connect to ACM:
```
$vagrant ssh acm
```
- Deploy kube cluster from ACM
```
cd /vagrant/ansiblev2
ansible-playbook -i ./inventory/inventory.ini -e @/vagrant/settings.yaml kube-master-setup.yml
```
- Pod installation using helm from ACM:
```
$cd /vagrant/helm
$ansible-playbook deploy_nginx_statefulset.yml
$ansible-playbook deploy_nginx_deployment.yml
```





# Vagrant cheatsheet:
```
Bring up the cluster:
$vagrant up

Destroy the cluster:
$vagrant destroy

Halt the cluster:
$vagrant halt

Connect to master:
$vagrant ssh master

Commect to acm:
$vagrant ssh acm

Connecet to worker:
$vagrant ssh node01
$vagrant ssh node02
```

# Troubleshoot:
kubeadm init not working due to stale data of last deployment.

```
Reset the kubeadm:
$vagrant ssh master
$sudo kubeadm reset

Sample init command to debug:
$sudo kubeadm init --apiserver-advertise-address=10.0.0.10 --apiserver-cert-extra-sans=10.0.0.10 --pod-network-cidr=172.16.1.0/16 --service-cidr=172.17.1.0/18 --node-name master-node --ignore-preflight-errors Swap
```