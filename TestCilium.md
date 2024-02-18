# Cilium use case1: L3-L7 rule: Demo
```
bash-3.2$ vagrant ssh master
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-83-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun Feb 18 05:21:14 PM UTC 2024

  System load:     0.24755859375      IPv4 address for cilium_host: 10.0.0.211
  Usage of /:      19.9% of 30.34GB   IPv4 address for cni0:        10.85.0.1
  Memory usage:    47%                IPv6 address for cni0:        1100:200::1
  Swap usage:      0%                 IPv4 address for eth0:        10.0.2.15
  Processes:       183                IPv4 address for eth1:        10.1.0.10
  Users logged in: 0


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sun Feb 18 17:19:13 2024 from 10.0.2.2
vagrant@master-node:~$ cd /vagrant/cilium
vagrant@master-node:/vagrant/cilium$ ./run_demo.sh
+ ./bring_up_setup.sh
+ echo 'List the pods and service before bringing up'
List the pods and service before bringing up
+ kubectl get pods,svc --all-namespaces -o wide
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE     IP           NODE            NOMINATED NODE   READINESS GATES
kube-system   pod/cilium-87s7l                          1/1     Running   0          5m40s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/cilium-94fp4                          1/1     Running   0          5m35s   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/cilium-bf287                          1/1     Running   0          5m35s   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/cilium-operator-684cb65b-dwgq2        1/1     Running   0          5m40s   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/cilium-operator-684cb65b-f2tx7        1/1     Running   0          5m41s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/coredns-5dd5756b68-g9rvn              1/1     Running   0          5m1s    10.0.0.254   master-node     <none>           <none>
kube-system   pod/coredns-5dd5756b68-p5c4p              1/1     Running   0          4m46s   10.0.0.35    master-node     <none>           <none>
kube-system   pod/etcd-master-node                      1/1     Running   0          5m54s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-apiserver-master-node            1/1     Running   0          5m54s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-controller-manager-master-node   1/1     Running   0          5m54s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-proxy-hd9cq                      1/1     Running   0          5m35s   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/kube-proxy-mm7rs                      1/1     Running   0          5m35s   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/kube-proxy-xf7cc                      1/1     Running   0          5m40s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-scheduler-master-node            1/1     Running   0          5m55s   10.1.0.10    master-node     <none>           <none>

NAMESPACE     NAME                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                  AGE     SELECTOR
default       service/kubernetes    ClusterIP   172.17.0.1     <none>        443/TCP                  5m56s   <none>
kube-system   service/hubble-peer   ClusterIP   172.17.51.27   <none>        443/TCP                  5m48s   k8s-app=cilium
kube-system   service/kube-dns      ClusterIP   172.17.0.10    <none>        53/UDP,53/TCP,9153/TCP   5m54s   k8s-app=kube-dns
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
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE     IP           NODE            NOMINATED NODE   READINESS GATES
default       pod/deathstar-f449b9b55-h87ht             1/1     Running   0          61s     10.0.2.254   worker-node02   <none>           <none>
default       pod/deathstar-f449b9b55-x6dtd             1/1     Running   0          61s     10.0.1.68    worker-node01   <none>           <none>
default       pod/tiefighter                            1/1     Running   0          61s     10.0.1.168   worker-node01   <none>           <none>
default       pod/xwing                                 1/1     Running   0          61s     10.0.1.89    worker-node01   <none>           <none>
kube-system   pod/cilium-87s7l                          1/1     Running   0          6m41s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/cilium-94fp4                          1/1     Running   0          6m36s   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/cilium-bf287                          1/1     Running   0          6m36s   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/cilium-operator-684cb65b-dwgq2        1/1     Running   0          6m41s   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/cilium-operator-684cb65b-f2tx7        1/1     Running   0          6m42s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/coredns-5dd5756b68-g9rvn              1/1     Running   0          6m2s    10.0.0.254   master-node     <none>           <none>
kube-system   pod/coredns-5dd5756b68-p5c4p              1/1     Running   0          5m47s   10.0.0.35    master-node     <none>           <none>
kube-system   pod/etcd-master-node                      1/1     Running   0          6m55s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-apiserver-master-node            1/1     Running   0          6m55s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-controller-manager-master-node   1/1     Running   0          6m55s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-proxy-hd9cq                      1/1     Running   0          6m36s   10.1.0.13    worker-node02   <none>           <none>
kube-system   pod/kube-proxy-mm7rs                      1/1     Running   0          6m36s   10.1.0.12    worker-node01   <none>           <none>
kube-system   pod/kube-proxy-xf7cc                      1/1     Running   0          6m41s   10.1.0.10    master-node     <none>           <none>
kube-system   pod/kube-scheduler-master-node            1/1     Running   0          6m56s   10.1.0.10    master-node     <none>           <none>

NAMESPACE     NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE     SELECTOR
default       service/deathstar     ClusterIP   172.17.16.216   <none>        80/TCP                   61s     class=deathstar,org=empire
default       service/kubernetes    ClusterIP   172.17.0.1      <none>        443/TCP                  6m57s   <none>
kube-system   service/hubble-peer   ClusterIP   172.17.51.27    <none>        443/TCP                  6m49s   k8s-app=cilium
kube-system   service/kube-dns      ClusterIP   172.17.0.10     <none>        53/UDP,53/TCP,9153/TCP   6m55s   k8s-app=kube-dns
+ ./test_connection.sh
Requesting landing from xwing to deathstar
Ship landed
Requesting landing from tiefighter to deathstar
Ship landed
+ ./apply_l4_policy.sh
+ echo 'List existing policy'
List existing policy
++ kubectl -n kube-system get pods -l k8s-app=cilium -o 'jsonpath={.items[*].metadata.name}'
+ pod_names='cilium-87s7l cilium-94fp4 cilium-bf287'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-87s7l'
Policy for pod: cilium-87s7l
+ kubectl -n kube-system exec cilium-87s7l -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
129        Disabled           Disabled          15786      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.35    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
194        Disabled           Disabled          15786      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.254   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
787        Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
2458       Disabled           Disabled          4          reserved:health                                                                     10.0.0.6     ready
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-94fp4'
Policy for pod: cilium-94fp4
+ kubectl -n kube-system exec cilium-94fp4 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
368        Disabled           Disabled          65013      k8s:app.kubernetes.io/name=tiefighter                                           10.0.1.168   ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
885        Disabled           Disabled          18165      k8s:app.kubernetes.io/name=xwing                                                10.0.1.89    ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
1658       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
3127       Disabled           Disabled          37288      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.68    ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
3311       Disabled           Disabled          4          reserved:health                                                                 10.0.1.94    ready
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-bf287'
Policy for pod: cilium-bf287
+ kubectl -n kube-system exec cilium-bf287 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
431        Disabled           Disabled          37288      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.254   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1303       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
3275       Disabled           Disabled          4          reserved:health                                                                 10.0.2.221   ready
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
+ pod_names='cilium-87s7l cilium-94fp4 cilium-bf287'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-87s7l'
Policy for pod: cilium-87s7l
+ kubectl -n kube-system exec cilium-87s7l -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
129        Disabled           Disabled          15786      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.35    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
194        Disabled           Disabled          15786      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.254   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
787        Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
2458       Disabled           Disabled          4          reserved:health                                                                     10.0.0.6     ready
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-94fp4'
Policy for pod: cilium-94fp4
+ kubectl -n kube-system exec cilium-94fp4 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
368        Disabled           Disabled          65013      k8s:app.kubernetes.io/name=tiefighter                                           10.0.1.168   ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
885        Disabled           Disabled          18165      k8s:app.kubernetes.io/name=xwing                                                10.0.1.89    ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
1658       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
3127       Enabled            Disabled          37288      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.68    ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
3311       Disabled           Disabled          4          reserved:health                                                                 10.0.1.94    ready
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-bf287'
Policy for pod: cilium-bf287
+ kubectl -n kube-system exec cilium-bf287 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
431        Enabled            Disabled          37288      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.254   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1303       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
3275       Disabled           Disabled          4          reserved:health                                                                 10.0.2.221   ready
+ kubectl describe cnp rule1
Name:         rule1
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  cilium.io/v2
Kind:         CiliumNetworkPolicy
Metadata:
  Creation Timestamp:  2024-02-18T17:22:35Z
  Generation:          1
  Resource Version:    1786
  UID:                 a0618103-ef71-4b78-a01a-cf087018fd2c
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
+ pod_names='cilium-87s7l cilium-94fp4 cilium-bf287'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-87s7l'
Policy for pod: cilium-87s7l
+ kubectl -n kube-system exec cilium-87s7l -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
129        Disabled           Disabled          15786      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.35    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
194        Disabled           Disabled          15786      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.254   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
787        Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
2458       Disabled           Disabled          4          reserved:health                                                                     10.0.0.6     ready
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-94fp4'
Policy for pod: cilium-94fp4
+ kubectl -n kube-system exec cilium-94fp4 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
368        Disabled           Disabled          65013      k8s:app.kubernetes.io/name=tiefighter                                           10.0.1.168   ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
885        Disabled           Disabled          18165      k8s:app.kubernetes.io/name=xwing                                                10.0.1.89    ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
1658       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
3127       Enabled            Disabled          37288      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.68    ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
3311       Disabled           Disabled          4          reserved:health                                                                 10.0.1.94    ready
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-bf287'
Policy for pod: cilium-bf287
+ kubectl -n kube-system exec cilium-bf287 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
431        Enabled            Disabled          37288      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.254   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1303       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
3275       Disabled           Disabled          4          reserved:health                                                                 10.0.2.221   ready
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
+ kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/sw_l3_l4_l7_policy.yaml
Error from server (AlreadyExists): error when creating "https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/sw_l3_l4_l7_policy.yaml": ciliumnetworkpolicies.cilium.io "rule1" already exists
+ echo 'Inspect updated policy'
Inspect updated policy
++ kubectl -n kube-system get pods -l k8s-app=cilium -o 'jsonpath={.items[*].metadata.name}'
+ pod_names='cilium-87s7l cilium-94fp4 cilium-bf287'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-87s7l'
Policy for pod: cilium-87s7l
+ kubectl -n kube-system exec cilium-87s7l -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
129        Disabled           Disabled          15786      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.35    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
194        Disabled           Disabled          15786      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.254   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
787        Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
2458       Disabled           Disabled          4          reserved:health                                                                     10.0.0.6     ready
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-94fp4'
Policy for pod: cilium-94fp4
+ kubectl -n kube-system exec cilium-94fp4 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
368        Disabled           Disabled          65013      k8s:app.kubernetes.io/name=tiefighter                                           10.0.1.168   ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
885        Disabled           Disabled          18165      k8s:app.kubernetes.io/name=xwing                                                10.0.1.89    ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
1658       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
3127       Enabled            Disabled          37288      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.68    ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
3311       Disabled           Disabled          4          reserved:health                                                                 10.0.1.94    ready
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-bf287'
Policy for pod: cilium-bf287
+ kubectl -n kube-system exec cilium-bf287 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
431        Enabled            Disabled          37288      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.254   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1303       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
3275       Disabled           Disabled          4          reserved:health                                                                 10.0.2.221   ready
+ kubectl describe ciliumnetworkpolicies
Name:         rule1
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  cilium.io/v2
Kind:         CiliumNetworkPolicy
Metadata:
  Creation Timestamp:  2024-02-18T17:22:35Z
  Generation:          1
  Resource Version:    1786
  UID:                 a0618103-ef71-4b78-a01a-cf087018fd2c
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
+ ./cleanup_setup.sh
+ kubectl delete -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/http-sw-app.yaml
service "deathstar" deleted
deployment.apps "deathstar" deleted
pod "tiefighter" deleted
pod "xwing" deleted
+ kubectl delete cnp rule1
ciliumnetworkpolicy.cilium.io "rule1" deleted
```

