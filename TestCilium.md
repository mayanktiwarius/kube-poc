# Cilium use case1: L3-L7 rule: Demo
```
bash-3.2$ vagrant ssh master
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-83-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun Feb 18 06:59:49 PM UTC 2024

  System load:     0.72998046875      IPv4 address for cilium_host: 10.0.0.46
  Usage of /:      19.9% of 30.34GB   IPv4 address for cni0:        10.85.0.1
  Memory usage:    47%                IPv6 address for cni0:        1100:200::1
  Swap usage:      0%                 IPv4 address for eth0:        10.0.2.15
  Processes:       165                IPv4 address for eth1:        10.1.0.10
  Users logged in: 0


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sun Feb 18 18:58:38 2024 from 10.0.2.2
vagrant@master-node:~$ cd /vagrant/cilium/
vagrant@master-node:/vagrant/cilium$
vagrant@master-node:/vagrant/cilium$
vagrant@master-node:/vagrant/cilium$
vagrant@master-node:/vagrant/cilium$ ./run_demo.sh
+ ./bring_up_setup.sh
+ echo 'List the pods and service before bringing up'
List the pods and service before bringing up
+ kubectl get pods,svc --all-namespaces -o wide
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE   IP           NODE            NOMINATED NODE   READINESS GATES
kube-system   pod/cilium-nfzdh                          1/1     Running   0          37m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/cilium-nk8jp                          1/1     Running   0          37m   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/cilium-operator-684cb65b-bdxmp        1/1     Running   0          37m   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/cilium-operator-684cb65b-bhmgd        1/1     Running   0          37m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/cilium-r8b6g                          1/1     Running   0          37m   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/coredns-5dd5756b68-52j65              1/1     Running   0          36m   10.0.0.59    master-node     <none>           <none>
kube-system   pod/coredns-5dd5756b68-gzfnk              1/1     Running   0          37m   10.0.0.164   master-node     <none>           <none>
kube-system   pod/etcd-master-node                      1/1     Running   0          37m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-apiserver-master-node            1/1     Running   0          37m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-controller-manager-master-node   1/1     Running   0          37m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-proxy-jrjpg                      1/1     Running   0          37m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-proxy-mdf8b                      1/1     Running   0          37m   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/kube-proxy-xc5bd                      1/1     Running   0          37m   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/kube-scheduler-master-node            1/1     Running   0          37m   10.1.0.10    master-node     <none>           <none>

NAMESPACE     NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE   SELECTOR
default       service/kubernetes    ClusterIP   172.17.0.1      <none>        443/TCP                  37m   <none>
kube-system   service/hubble-peer   ClusterIP   172.17.18.132   <none>        443/TCP                  37m   k8s-app=cilium
kube-system   service/kube-dns      ClusterIP   172.17.0.10     <none>        53/UDP,53/TCP,9153/TCP   37m   k8s-app=kube-dns
+ echo 'Installation of all pods'
Installation of all pods
+ kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/http-sw-app.yaml
service/deathstar created
deployment.apps/deathstar created
pod/tiefighter created
pod/xwing created
+ echo 'Waiting for 1 min for pods to come up'
Waiting for 1 min for pods to come up
+ sleep 60
+ echo 'List the pods and service after bringing up'
List the pods and service after bringing up
+ kubectl get pods,svc --all-namespaces -o wide
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE   IP           NODE            NOMINATED NODE   READINESS GATES
default       pod/deathstar-f449b9b55-88t5t             1/1     Running   0          60s   10.0.2.233   worker-node01   <none>           <none>
default       pod/deathstar-f449b9b55-srjdc             1/1     Running   0          60s   10.0.1.135   worker-node02   <none>           <none>
default       pod/tiefighter                            1/1     Running   0          60s   10.0.1.76    worker-node02   <none>           <none>
default       pod/xwing                                 1/1     Running   0          60s   10.0.2.175   worker-node01   <none>           <none>
kube-system   pod/cilium-nfzdh                          1/1     Running   0          38m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/cilium-nk8jp                          1/1     Running   0          38m   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/cilium-operator-684cb65b-bdxmp        1/1     Running   0          38m   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/cilium-operator-684cb65b-bhmgd        1/1     Running   0          38m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/cilium-r8b6g                          1/1     Running   0          38m   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/coredns-5dd5756b68-52j65              1/1     Running   0          37m   10.0.0.59    master-node     <none>           <none>
kube-system   pod/coredns-5dd5756b68-gzfnk              1/1     Running   0          38m   10.0.0.164   master-node     <none>           <none>
kube-system   pod/etcd-master-node                      1/1     Running   0          38m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-apiserver-master-node            1/1     Running   0          38m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-controller-manager-master-node   1/1     Running   0          38m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-proxy-jrjpg                      1/1     Running   0          38m   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-proxy-mdf8b                      1/1     Running   0          38m   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/kube-proxy-xc5bd                      1/1     Running   0          38m   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/kube-scheduler-master-node            1/1     Running   0          38m   10.1.0.10    master-node     <none>           <none>

NAMESPACE     NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE   SELECTOR
default       service/deathstar     ClusterIP   172.17.5.174    <none>        80/TCP                   60s   class=deathstar,org=empire
default       service/kubernetes    ClusterIP   172.17.0.1      <none>        443/TCP                  38m   <none>
kube-system   service/hubble-peer   ClusterIP   172.17.18.132   <none>        443/TCP                  38m   k8s-app=cilium
kube-system   service/kube-dns      ClusterIP   172.17.0.10     <none>        53/UDP,53/TCP,9153/TCP   38m   k8s-app=kube-dns
+ ./test_connection.sh
Requesting landing from xwing to deathstar
Ship landed
Requesting landing from tiefighter to deathstar
Ship landed
+ ./apply_l4_policy.sh
+ echo 'List existing policy'
List existing policy
++ kubectl -n kube-system get pods -l k8s-app=cilium -o 'jsonpath={.items[*].metadata.name}'
+ pod_names='cilium-nfzdh cilium-nk8jp cilium-r8b6g'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-nfzdh'
Policy for pod: cilium-nfzdh
+ kubectl -n kube-system exec cilium-nfzdh -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
570        Disabled           Disabled          16288      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.164   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
1584       Disabled           Disabled          4          reserved:health                                                                     10.0.0.153   ready
3570       Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
3599       Disabled           Disabled          16288      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.59    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-nk8jp'
Policy for pod: cilium-nk8jp
+ kubectl -n kube-system exec cilium-nk8jp -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
783        Disabled           Disabled          23744      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.135   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1645       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
2034       Disabled           Disabled          4          reserved:health                                                                 10.0.1.42    ready
2098       Disabled           Disabled          14788      k8s:app.kubernetes.io/name=tiefighter                                           10.0.1.76    ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-r8b6g'
Policy for pod: cilium-r8b6g
+ kubectl -n kube-system exec cilium-r8b6g -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
483        Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
831        Disabled           Disabled          12264      k8s:app.kubernetes.io/name=xwing                                                10.0.2.175   ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
2259       Disabled           Disabled          4          reserved:health                                                                 10.0.2.156   ready
3115       Disabled           Disabled          23744      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.233   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
+ echo 'Apply policy'
Apply policy
+ curl https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/sw_l3_l4_policy.yaml
apiVersion: "cilium.io/v2"
kind: CiliumNetworkPolicy
metadata:
  name: "rule1"
spec:
  description: "L3-L4 policy to restrict deathstar access to empire ships only"
  endpointSelector:
    matchLabels:
      org: empire
      class: deathstar
  ingress:
  - fromEndpoints:
    - matchLabels:
        org: empire
    toPorts:
    - ports:
      - port: "80"
        protocol: TCP
+ kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/sw_l3_l4_policy.yaml
ciliumnetworkpolicy.cilium.io/rule1 created
+ echo 'Inspect updated policy'
Inspect updated policy
++ kubectl -n kube-system get pods -l k8s-app=cilium -o 'jsonpath={.items[*].metadata.name}'
+ pod_names='cilium-nfzdh cilium-nk8jp cilium-r8b6g'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-nfzdh'
Policy for pod: cilium-nfzdh
+ kubectl -n kube-system exec cilium-nfzdh -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
570        Disabled           Disabled          16288      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.164   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
1584       Disabled           Disabled          4          reserved:health                                                                     10.0.0.153   ready
3570       Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
3599       Disabled           Disabled          16288      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.59    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-nk8jp'
Policy for pod: cilium-nk8jp
+ kubectl -n kube-system exec cilium-nk8jp -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
783        Enabled            Disabled          23744      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.135   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1645       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
2034       Disabled           Disabled          4          reserved:health                                                                 10.0.1.42    ready
2098       Disabled           Disabled          14788      k8s:app.kubernetes.io/name=tiefighter                                           10.0.1.76    ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-r8b6g'
Policy for pod: cilium-r8b6g
+ kubectl -n kube-system exec cilium-r8b6g -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
483        Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
831        Disabled           Disabled          12264      k8s:app.kubernetes.io/name=xwing                                                10.0.2.175   ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
2259       Disabled           Disabled          4          reserved:health                                                                 10.0.2.156   ready
3115       Enabled            Disabled          23744      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.233   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
+ kubectl describe cnp rule1
Name:         rule1
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  cilium.io/v2
Kind:         CiliumNetworkPolicy
Metadata:
  Creation Timestamp:  2024-02-18T19:01:15Z
  Generation:          1
  Resource Version:    6138
  UID:                 19020990-fa46-4e18-bf82-b0ba56a9baef
Spec:
  Description:  L3-L4 policy to restrict deathstar access to empire ships only
  Endpoint Selector:
    Match Labels:
      Class:  deathstar
      Org:    empire
  Ingress:
    From Endpoints:
      Match Labels:
        Org:  empire
    To Ports:
      Ports:
        Port:      80
        Protocol:  TCP
Events:            <none>
+ ./test_connection.sh
Requesting landing from xwing to deathstar
Request for landing of xwing to deathstar failed
Requesting landing from tiefighter to deathstar
Ship landed
+ ./apply_l7_policy.sh
+ echo 'List existing policy'
List existing policy
++ kubectl -n kube-system get pods -l k8s-app=cilium -o 'jsonpath={.items[*].metadata.name}'
+ pod_names='cilium-nfzdh cilium-nk8jp cilium-r8b6g'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-nfzdh'
Policy for pod: cilium-nfzdh
+ kubectl -n kube-system exec cilium-nfzdh -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
570        Disabled           Disabled          16288      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.164   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
1584       Disabled           Disabled          4          reserved:health                                                                     10.0.0.153   ready
3570       Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
3599       Disabled           Disabled          16288      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.59    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-nk8jp'
Policy for pod: cilium-nk8jp
+ kubectl -n kube-system exec cilium-nk8jp -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
783        Enabled            Disabled          23744      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.135   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1645       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
2034       Disabled           Disabled          4          reserved:health                                                                 10.0.1.42    ready
2098       Disabled           Disabled          14788      k8s:app.kubernetes.io/name=tiefighter                                           10.0.1.76    ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-r8b6g'
Policy for pod: cilium-r8b6g
+ kubectl -n kube-system exec cilium-r8b6g -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
483        Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
831        Disabled           Disabled          12264      k8s:app.kubernetes.io/name=xwing                                                10.0.2.175   ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
2259       Disabled           Disabled          4          reserved:health                                                                 10.0.2.156   ready
3115       Enabled            Disabled          23744      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.233   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
+ echo 'Apply policy'
Apply policy
+ curl https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/sw_l3_l4_l7_policy.yaml
apiVersion: "cilium.io/v2"
kind: CiliumNetworkPolicy
metadata:
  name: "rule1"
spec:
  description: "L7 policy to restrict access to specific HTTP call"
  endpointSelector:
    matchLabels:
      org: empire
      class: deathstar
  ingress:
  - fromEndpoints:
    - matchLabels:
        org: empire
    toPorts:
    - ports:
      - port: "80"
        protocol: TCP
      rules:
        http:
        - method: "POST"
          path: "/v1/request-landing"
+ kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/sw_l3_l4_l7_policy.yaml
Warning: resource ciliumnetworkpolicies/rule1 is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
ciliumnetworkpolicy.cilium.io/rule1 configured
+ echo 'Wait for 15 seconds for policy to get applied'
Wait for 15 seconds for policy to get applied
+ sleep 15
+ echo 'Inspect updated policy'
Inspect updated policy
++ kubectl -n kube-system get pods -l k8s-app=cilium -o 'jsonpath={.items[*].metadata.name}'
+ pod_names='cilium-nfzdh cilium-nk8jp cilium-r8b6g'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-nfzdh'
Policy for pod: cilium-nfzdh
+ kubectl -n kube-system exec cilium-nfzdh -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
570        Disabled           Disabled          16288      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.164   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
1584       Disabled           Disabled          4          reserved:health                                                                     10.0.0.153   ready
3570       Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
3599       Disabled           Disabled          16288      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.59    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-nk8jp'
Policy for pod: cilium-nk8jp
+ kubectl -n kube-system exec cilium-nk8jp -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
783        Enabled            Disabled          23744      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.135   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1645       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
2034       Disabled           Disabled          4          reserved:health                                                                 10.0.1.42    ready
2098       Disabled           Disabled          14788      k8s:app.kubernetes.io/name=tiefighter                                           10.0.1.76    ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-r8b6g'
Policy for pod: cilium-r8b6g
+ kubectl -n kube-system exec cilium-r8b6g -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
483        Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
831        Disabled           Disabled          12264      k8s:app.kubernetes.io/name=xwing                                                10.0.2.175   ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
2259       Disabled           Disabled          4          reserved:health                                                                 10.0.2.156   ready
3115       Enabled            Disabled          23744      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.233   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
+ kubectl describe ciliumnetworkpolicies
Name:         rule1
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  cilium.io/v2
Kind:         CiliumNetworkPolicy
Metadata:
  Creation Timestamp:  2024-02-18T19:01:15Z
  Generation:          2
  Resource Version:    6149
  UID:                 19020990-fa46-4e18-bf82-b0ba56a9baef
Spec:
  Description:  L7 policy to restrict access to specific HTTP call
  Endpoint Selector:
    Match Labels:
      Class:  deathstar
      Org:    empire
  Ingress:
    From Endpoints:
      Match Labels:
        Org:  empire
    To Ports:
      Ports:
        Port:      80
        Protocol:  TCP
      Rules:
        Http:
          Method:  POST
          Path:    /v1/request-landing
Events:            <none>
+ ./test_connection.sh
Requesting landing from xwing to deathstar
Request for landing of xwing to deathstar failed
Requesting landing from tiefighter to deathstar
Ship landed
+ ./test_connection_l7.sh
Requesting landing from tiefighter to deathstar on enabled api
Ship landed
Requesting landing from tiefighter to deathstar on disabled api
Access denied
+ ./cleanup_setup.sh
+ kubectl delete -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/http-sw-app.yaml
service "deathstar" deleted
deployment.apps "deathstar" deleted
pod "tiefighter" deleted
pod "xwing" deleted
+ kubectl delete cnp rule1
ciliumnetworkpolicy.cilium.io "rule1" deleted
vagrant@master-node:/vagrant/cilium$
```

