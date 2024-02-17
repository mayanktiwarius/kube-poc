# Cilium use case1: L3-L7 rule: Demo
```
$ vagrant ssh master
vagrant@master-node:~$ cd /vagrant/cilium/
vagrant@master-node:/vagrant/cilium$ ./run_demo.sh
+ ./bring_up_setup.sh
+ echo 'Installation of all pods'
Installation of all pods
+ kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.1/examples/minikube/http-sw-app.yaml
service/deathstar created
deployment.apps/deathstar created
pod/tiefighter created
pod/xwing created
+ echo 'List the pods and service'
List the pods and service
+ kubectl get pods,svc
NAME                            READY   STATUS              RESTARTS   AGE
pod/deathstar-f449b9b55-8jpdz   0/1     ContainerCreating   0          1s
pod/deathstar-f449b9b55-96r97   0/1     ContainerCreating   0          1s
pod/tiefighter                  0/1     ContainerCreating   0          1s
pod/xwing                       0/1     ContainerCreating   0          1s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/deathstar    ClusterIP   172.17.18.207   <none>        80/TCP    1s
service/kubernetes   ClusterIP   172.17.0.1      <none>        443/TCP   84m
+ ./test_connection.sh
Requesting landing from xwing to deathstar
error: unable to upgrade connection: container not found ("spaceship")
Request for landing of xwing to deathstar failed
Requesting landing from tiefighter to deathstar
error: unable to upgrade connection: container not found ("spaceship")
Request for landing of tiefighter to deathstar failed
+ ./apply_l4_policy.sh
+ echo 'List existing policy'
List existing policy
++ kubectl -n kube-system get pods -l k8s-app=cilium -o 'jsonpath={.items[*].metadata.name}'
+ pod_names='cilium-7qkmf cilium-8z2h4 cilium-9hlbb'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-7qkmf'
Policy for pod: cilium-7qkmf
+ kubectl -n kube-system exec cilium-7qkmf -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                 IPv6   IPv4        STATUS
           ENFORCEMENT        ENFORCEMENT
905        Disabled           Disabled          4          reserved:health                                    10.0.2.58   ready
2045       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                      ready
                                                           reserved:host
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-8z2h4'
Policy for pod: cilium-8z2h4
+ kubectl -n kube-system exec cilium-8z2h4 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
181        Disabled           Disabled          10295      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.216   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
669        Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
1657       Disabled           Disabled          4          reserved:health                                                                     10.0.0.157   ready
1808       Disabled           Disabled          10295      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.23    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-9hlbb'
Policy for pod: cilium-9hlbb
+ kubectl -n kube-system exec cilium-9hlbb -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
242        Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
898        Disabled           Disabled          43264      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.97    ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1377       Disabled           Disabled          4          reserved:health                                                                 10.0.1.195   ready
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
+ pod_names='cilium-7qkmf cilium-8z2h4 cilium-9hlbb'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-7qkmf'
Policy for pod: cilium-7qkmf
+ kubectl -n kube-system exec cilium-7qkmf -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
905        Disabled           Disabled          4          reserved:health                                                                 10.0.2.58    ready
1002       Enabled            Disabled          43264      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.239   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1764       Disabled           Disabled          13669      k8s:app.kubernetes.io/name=tiefighter                                           10.0.2.202   ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
2000       Disabled           Disabled          34944      k8s:app.kubernetes.io/name=xwing                                                10.0.2.244   ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
2045       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-8z2h4'
Policy for pod: cilium-8z2h4
+ kubectl -n kube-system exec cilium-8z2h4 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
181        Disabled           Disabled          10295      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.216   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
669        Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
1657       Disabled           Disabled          4          reserved:health                                                                     10.0.0.157   ready
1808       Disabled           Disabled          10295      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.23    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-9hlbb'
Policy for pod: cilium-9hlbb
+ kubectl -n kube-system exec cilium-9hlbb -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
242        Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
898        Enabled            Disabled          43264      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.97    ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1377       Disabled           Disabled          4          reserved:health                                                                 10.0.1.195   ready
+ kubectl describe cnp rule1
Name:         rule1
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  cilium.io/v2
Kind:         CiliumNetworkPolicy
Metadata:
  Creation Timestamp:  2024-02-17T17:58:20Z
  Generation:          1
  Resource Version:    11547
  UID:                 ef3ecd39-c372-4f44-a2fe-cae940bf7a82
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
+ pod_names='cilium-7qkmf cilium-8z2h4 cilium-9hlbb'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-7qkmf'
Policy for pod: cilium-7qkmf
+ kubectl -n kube-system exec cilium-7qkmf -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
905        Disabled           Disabled          4          reserved:health                                                                 10.0.2.58    ready
1002       Enabled            Disabled          43264      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.239   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1764       Disabled           Disabled          13669      k8s:app.kubernetes.io/name=tiefighter                                           10.0.2.202   ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
2000       Disabled           Disabled          34944      k8s:app.kubernetes.io/name=xwing                                                10.0.2.244   ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
2045       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-8z2h4'
Policy for pod: cilium-8z2h4
+ kubectl -n kube-system exec cilium-8z2h4 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
181        Disabled           Disabled          10295      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.216   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
669        Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
1657       Disabled           Disabled          4          reserved:health                                                                     10.0.0.157   ready
1808       Disabled           Disabled          10295      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.23    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-9hlbb'
Policy for pod: cilium-9hlbb
+ kubectl -n kube-system exec cilium-9hlbb -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
242        Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
898        Enabled            Disabled          43264      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.97    ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1377       Disabled           Disabled          4          reserved:health                                                                 10.0.1.195   ready
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
+ pod_names='cilium-7qkmf cilium-8z2h4 cilium-9hlbb'
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-7qkmf'
Policy for pod: cilium-7qkmf
+ kubectl -n kube-system exec cilium-7qkmf -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
905        Disabled           Disabled          4          reserved:health                                                                 10.0.2.58    ready
1002       Enabled            Disabled          43264      k8s:app.kubernetes.io/name=deathstar                                            10.0.2.239   ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1764       Disabled           Disabled          13669      k8s:app.kubernetes.io/name=tiefighter                                           10.0.2.202   ready
                                                           k8s:class=tiefighter
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
2000       Disabled           Disabled          34944      k8s:app.kubernetes.io/name=xwing                                                10.0.2.244   ready
                                                           k8s:class=xwing
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=alliance
2045       Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-8z2h4'
Policy for pod: cilium-8z2h4
+ kubectl -n kube-system exec cilium-8z2h4 -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                                  IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
181        Disabled           Disabled          10295      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.216   ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
669        Disabled           Disabled          1          k8s:node-role.kubernetes.io/control-plane                                                        ready
                                                           k8s:node.kubernetes.io/exclude-from-external-load-balancers
                                                           reserved:host
1657       Disabled           Disabled          4          reserved:health                                                                     10.0.0.157   ready
1808       Disabled           Disabled          10295      k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=kube-system          10.0.0.23    ready
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=coredns
                                                           k8s:io.kubernetes.pod.namespace=kube-system
                                                           k8s:k8s-app=kube-dns
+ for pod in $pod_names
+ echo 'Policy for pod: cilium-9hlbb'
Policy for pod: cilium-9hlbb
+ kubectl -n kube-system exec cilium-9hlbb -- cilium-dbg endpoint list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
ENDPOINT   POLICY (ingress)   POLICY (egress)   IDENTITY   LABELS (source:key[=value])                                              IPv6   IPv4         STATUS
           ENFORCEMENT        ENFORCEMENT
242        Disabled           Disabled          1          k8s:node-role.kubernetes.io/worker=worker                                                    ready
                                                           reserved:host
898        Enabled            Disabled          43264      k8s:app.kubernetes.io/name=deathstar                                            10.0.1.97    ready
                                                           k8s:class=deathstar
                                                           k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default
                                                           k8s:io.cilium.k8s.policy.cluster=default
                                                           k8s:io.cilium.k8s.policy.serviceaccount=default
                                                           k8s:io.kubernetes.pod.namespace=default
                                                           k8s:org=empire
1377       Disabled           Disabled          4          reserved:health                                                                 10.0.1.195   ready
+ kubectl describe ciliumnetworkpolicies
Name:         rule1
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  cilium.io/v2
Kind:         CiliumNetworkPolicy
Metadata:
  Creation Timestamp:  2024-02-17T17:58:20Z
  Generation:          1
  Resource Version:    11547
  UID:                 ef3ecd39-c372-4f44-a2fe-cae940bf7a82
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

