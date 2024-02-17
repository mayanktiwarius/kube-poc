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


# Pod installation/uinstallation using helm from ACM: (optional not needed for)
```
Installation steps:
$vagrant ssh acm
$cd /vagrant/helm
$./install_pods.sh
$vagrant ssh master
$ kubectl get pods
Pods should be listed

Uninstallation steps:
$vagrant ssh acm
$cd /vagrant/helm
$./uninstall_pods.sh
$vagrant ssh master
$ kubectl get pods
Pods should not be listed
```

# Cilium use case1: L3-L7 rule
https://docs.cilium.io/en/stable/gettingstarted/demo/

Playbook execution to see all in one shot:

```
1. Connect to master
$vagrant ssh master
2. Run the demo
$ ./run_demo.sh
```

OR

Step by step execution to observe the changes done by each step:
```
1. Connect to master
$vagrant ssh master
2. Bring up the setup
$ cd /vagrant/cilium
$ ./bring_up_setup.sh
3. Demo that L3/L4 connection works for both pods before policy is applied
$ ./test_connection.sh
4. Apply l3/l4 policy
$ ./apply_l4_policy.sh
5. Demo that L3/L4 connection work for one pod and not for another pod
$ ./test_connection.sh
6. Apply l7 policy
$ ./apply_l7_policy.sh
7. Demo that L7 connection work for one pod and not for another pod
$ ./test_connection.sh
7. Clean up the setup
$ ./cleanup_setup.sh

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

# Helm cheatsheet:
```
Create new chart
$helm create mychart

List helm installed:
$helm list

Check the spec created from template:
$helm template test-release ./helm-project/
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




# Cilium use case2: (WIP) 
https://cilium.io/blog/2020/07/27/2020-07-27-multitenancy-network-security/
```
IP addresses aren't suitable for identities in Kubernetes because Pod Replicas can have N number of IP addresses for a single workload. Additionally, correlating a Pod to an IP address is difficult in a highly dynamic environment like Kubernetes, as Pods can be quickly destroyed and re-scheduled, each time with a different IP address. So if you have a Pod with labels frontend, and you delete the Pod and quickly spin up a new Pod, Kubernetes is free to reassign the frontend IP to a new Pod that has the label agent_of_chaos.

To update the security policy in a traditional IP-based model, Nodes have to learn about the Pod shut down and then update the policy rules to remove the IP address from IP allow lists. In the meantime, the agent_of_chaos Pod can initialize using the same IP and send traffic to other Pods with the frontend IP address, and IP-based policy may allow it.

Cilium identifies a network entity with an identity instead of an IP address. Identities are derived from Kubernetes labels and other metadata which allows security logic such as, "Only allow frontend Pods access to backend Pods". This allows for identity-aware security decisions such as Network Policy filtering.
```

# Cilium use case2 approach: (WIP) 
```
1. Without policy backend can be reached from both frontend and agent-of-chaos
2. Apply the policy from master:
cd /vagrant/ansiblev2
kubectl apply -f cilium_policy.yaml
3. After applying policy frontend can reach backend but agent-of-chaos cannot reach backend

```
Reference: 
https://github.com/cilium/cilium/tree/main/examples/policies/kubernetes
Subrefernce: 
https://github.com/cilium/cilium/blob/main/examples/policies/kubernetes/namespace/namespace-policy.yaml



# Notes
## Command to bring up cilium
```
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.15.0 \
  --namespace kube-system \
  --set kubeProxyReplacement=partial \
  --set hostServices.enabled=true \
  --set externalIPs.enabled=true \
  --set nodePort.enabled=true \
  --set hostPort.enabled=true \
  --set bpf.masquerade=false \
  --set image.pullPolicy=IfNotPresent
```