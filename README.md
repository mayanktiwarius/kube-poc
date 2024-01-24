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
/vagrant/ansiblev2
ansible-playbook -i ./inventory/inventory.ini -e @/vagrant/settings.yaml kube-master-setup.yml

