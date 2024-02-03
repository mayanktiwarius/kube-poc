# Pod eviction process testing
## Tolerations added to pod
```
tolerations:
- key: node.kubernetes.io/network-unavailable
  operator: Exists
  effect: NoExecute
  tolerationSeconds: 30
- effect: NoExecute
  key: node.kubernetes.io/not-ready
  operator: Exists
  tolerationSeconds: 30
- effect: NoExecute
  key: node.kubernetes.io/unreachable
  operator: Exists
  tolerationSeconds: 30
  ```


### Simulate one of the scenarios:
```
node.kubernetes.io/network-unavailable
```

##### Add taint to node:
```
kubectl taint nodes <node-name> node.kubernetes.io/network-unavailable=true:NoExecute
```

##### Check the pod movement:
- Before adding taint to worker-node01:
```
vagrant@master-node:~$ kubectl get pods -o wide
NAME                                                READY   STATUS    RESTARTS   AGE     IP              NODE            NOMINATED NODE   READINESS GATES
nginx-deployment-nginxdeployment-7c96647cbb-656pl   1/1     Running   0          5m26s   172.16.158.15   worker-node02   <none>           <none>
nginx-stateful-nginxstateful-0                      1/1     Running   0          7m6s    172.16.87.207   worker-node01   <none>           <none>
```

- After adding taint to worker-node01:
```
Terminating on old worker node:
vagrant@master-node:~$ kubectl get pods -o wide
NAME                                                READY   STATUS        RESTARTS   AGE     IP              NODE            NOMINATED NODE   READINESS GATES
nginx-deployment-nginxdeployment-7c96647cbb-656pl   1/1     Running       0          7m13s   172.16.158.15   worker-node02   <none>           <none>
nginx-stateful-nginxstateful-0                      1/1     Terminating   0          8m53s   172.16.87.207   worker-node01   <none>           <none>

Pod get reschedule on same worker node due to toleration to the taint but delete again because of the taint since this is simulation.
In real world the pod will not come back on this node as this worker node is not reachable.
vagrant@master-node:~$ kubectl get pods -o wide
NAME                                                READY   STATUS    RESTARTS   AGE     IP              NODE            NOMINATED NODE   READINESS GATES
nginx-deployment-nginxdeployment-7c96647cbb-656pl   1/1     Running   0          7m26s   172.16.158.15   worker-node02   <none>           <none>
nginx-stateful-nginxstateful-0                      1/1     Running   0          12s     172.16.87.208   worker-node01   <none>           <none>
```


- Remove taint from the worker node:
```
kubectl taint nodes <node-name> node.kubernetes.io/network-unavailable-
```

Likewise it can be done for other tolerations above.


## Actual test by bring down master or worker nodes:

##### Test1: Worker node bring down test

- Bring down worker node:
```
$ vagrant halt node01

vagrant@master-node:~$ kubectl get nodes
NAME            STATUS     ROLES           AGE   VERSION
master-node     Ready      control-plane   12h   v1.28.2
worker-node01   NotReady   worker          12h   v1.28.2
worker-node02   Ready      worker          12h   v1.28.2

Pod terminating after 30 seconds but will hang in termiating state forever till the node where it is schedule comes up successfully:
vagrant@master-node:~$ kubectl get pods -o wide
NAME                                                READY   STATUS        RESTARTS   AGE     IP              NODE            NOMINATED NODE   READINESS GATES
nginx-deployment-nginxdeployment-7c96647cbb-656pl   1/1     Running       0          17m     172.16.158.15   worker-node02   <none>           <none>
nginx-stateful-nginxstateful-0                      1/1     Terminating   0          5m31s   172.16.87.215   worker-node01   <none>           <none>

Stuck forever:
vagrant@master-node:~$ kubectl get pods -o wide
NAME                                                READY   STATUS        RESTARTS   AGE     IP              NODE            NOMINATED NODE   READINESS GATES
nginx-deployment-nginxdeployment-7c96647cbb-656pl   1/1     Running       0          18m     172.16.158.15   worker-node02   <none>           <none>
nginx-stateful-nginxstateful-0                      1/1     Terminating   0          6m44s   172.16.87.215   worker-node01   <none>           <none>
```

- Worker node is up:
```
$ vagrant up node01

vagrant@master-node:~$ kubectl get nodes
NAME            STATUS   ROLES           AGE   VERSION
master-node     Ready    control-plane   12h   v1.28.2
worker-node01   Ready    worker          12h   v1.28.2
worker-node02   Ready    worker          12h   v1.28.2
vagrant@master-node:~$ kubectl get pods -o wide
NAME                                                READY   STATUS    RESTARTS   AGE   IP              NODE            NOMINATED NODE   READINESS GATES
nginx-deployment-nginxdeployment-7c96647cbb-656pl   1/1     Running   0          20m   172.16.158.15   worker-node02   <none>           <none>
nginx-stateful-nginxstateful-0                      1/1     Running   0          18s   172.16.87.216   worker-node01   <none>           <none>
```

##### Test2: Master node bring down test (Expection: All pods should keep running forever)

- State of the pods before master bring down
```
Master:
root@master-node:/home/vagrant# crictl ps
CONTAINER           IMAGE                                                              CREATED             STATE               NAME                      ATTEMPT             POD ID              POD
b15cfded8050d       7597ecaaf12074e2980eee086736dbd01e566dc266351560001aa47dbbb0e5fe   12 hours ago        Running             kube-scheduler            6                   bb88bdece1b36       kube-scheduler-master-node
17584e2bf8f33       18dbd2df3bb54036300d2af8b20ef60d479173946ff089a4d16e258b27faa55c   12 hours ago        Running             kube-controller-manager   6                   ebfb5fac6c8c6       kube-controller-manager-master-node
33318f5bf0914       ead0a4a53df89fd173874b46093b6e62d8c72967bbf606d672c9e8c9b601a4fc   13 hours ago        Running             coredns                   0                   d0a4a1d26732d       coredns-5dd5756b68-fhc4l
3d2b0f3c56e0c       5e785d005ccc1ab22527a783835cf2741f6f5f385a8956144c661f8c23ae9d78   13 hours ago        Running             calico-kube-controllers   0                   7f0c53a514b0e       calico-kube-controllers-658d97c59c-k8ngl
da5c6615afe6c       ead0a4a53df89fd173874b46093b6e62d8c72967bbf606d672c9e8c9b601a4fc   13 hours ago        Running             coredns                   0                   4249982a0e71e       coredns-5dd5756b68-pbqtv
805578c946b1e       08616d26b8e74867402274687491e5978ba4a6ded94e9f5ecc3e364024e5683e   13 hours ago        Running             calico-node               0                   b5a01b8138f0a       calico-node-dvwqt
f42c06464e566       342a759d88156b4f56ba522a1aed0e3d32d72542545346b40877f6583bebe05f   13 hours ago        Running             kube-proxy                0                   3302c6cb9b9f5       kube-proxy-lfqpg
76db30c666f06       73deb9a3f702532592a4167455f8bf2e5f5d900bcc959ba2fd2d35c321de1af9   13 hours ago        Running             etcd                      4                   a2a819ef78343       etcd-master-node
9b7a90b826c2d       70e88c5e3a8e409ff4604a5fdb1dacb736ea02ba0b7a3da635f294e953906f47   13 hours ago        Running             kube-apiserver            4                   31e8a6f5a1e0e       kube-apiserver-master-node

Worker1:
vagrant@worker-node01:~$ sudo su
root@worker-node01:/home/vagrant# crictl ps
CONTAINER           IMAGE                                                              CREATED             STATE               NAME                ATTEMPT             POD ID              POD
d51e036fb39ef       08616d26b8e74867402274687491e5978ba4a6ded94e9f5ecc3e364024e5683e   5 minutes ago       Running             calico-node         1                   cef42271f35de       calico-node-l6v9m
47937ad871734       b690f5f0a2d535cee5e08631aa508fef339c43bb91d5b1f7d77a1a05cea021a8   5 minutes ago       Running             nginxstateful       0                   6b2be435a70e1       nginx-stateful-nginxstateful-0
49fec7e6c6492       342a759d88156b4f56ba522a1aed0e3d32d72542545346b40877f6583bebe05f   5 minutes ago       Running             kube-proxy          1                   5a3fdc53d38d7       kube-proxy-wjcdf

Worker2:
root@worker-node02:/home/vagrant# crictl ps
CONTAINER           IMAGE                                                              CREATED             STATE               NAME                ATTEMPT             POD ID              POD
717bcad0d4081       b690f5f0a2d535cee5e08631aa508fef339c43bb91d5b1f7d77a1a05cea021a8   25 minutes ago      Running             nginxdeployment     0                   0d5d528f41cdc       nginx-deployment-nginxdeployment-7c96647cbb-656pl
3ba96a1244e34       08616d26b8e74867402274687491e5978ba4a6ded94e9f5ecc3e364024e5683e   13 hours ago        Running             calico-node         0                   2b5641692fbb0       calico-node-vrrcd
a9a5caf4b7898       342a759d88156b4f56ba522a1aed0e3d32d72542545346b40877f6583bebe05f   13 hours ago        Running             kube-proxy          0                   cd9fc48065c9a       kube-proxy-nfw6s
```
- Stopping master:
```
$ vagrant halt master
```

- Check after master is down:
```
Worker1:
root@worker-node01:/home/vagrant# crictl ps
CONTAINER           IMAGE                                                              CREATED             STATE               NAME                ATTEMPT             POD ID              POD
d51e036fb39ef       08616d26b8e74867402274687491e5978ba4a6ded94e9f5ecc3e364024e5683e   8 minutes ago       Running             calico-node         1                   cef42271f35de       calico-node-l6v9m
47937ad871734       b690f5f0a2d535cee5e08631aa508fef339c43bb91d5b1f7d77a1a05cea021a8   8 minutes ago       Running             nginxstateful       0                   6b2be435a70e1       nginx-stateful-nginxstateful-0
49fec7e6c6492       342a759d88156b4f56ba522a1aed0e3d32d72542545346b40877f6583bebe05f   8 minutes ago       Running             kube-proxy          1                   5a3fdc53d38d7       kube-proxy-wjcdf


Worker2:

root@worker-node02:/home/vagrant# crictl ps
CONTAINER           IMAGE                                                              CREATED             STATE               NAME                ATTEMPT             POD ID              POD
717bcad0d4081       b690f5f0a2d535cee5e08631aa508fef339c43bb91d5b1f7d77a1a05cea021a8   29 minutes ago      Running             nginxdeployment     0                   0d5d528f41cdc       nginx-deployment-nginxdeployment-7c96647cbb-656pl
3ba96a1244e34       08616d26b8e74867402274687491e5978ba4a6ded94e9f5ecc3e364024e5683e   13 hours ago        Running             calico-node         0                   2b5641692fbb0       calico-node-vrrcd
a9a5caf4b7898       342a759d88156b4f56ba522a1aed0e3d32d72542545346b40877f6583bebe05f   13 hours ago        Running             kube-proxy          0                   cd9fc48065c9a       kube-proxy-nfw6s

All URLS are working after master is down:
http://10.0.0.13:32000/
http://10.0.0.12:32000/
http://10.0.0.13:32001/
http://10.0.0.12:32001/

```

- Check 4 hours after master is down:

```

All containers are up and also service working

root@worker-node01:/home/vagrant# crictl ps
CONTAINER           IMAGE                                                              CREATED             STATE               NAME                ATTEMPT             POD ID              POD
d51e036fb39ef       08616d26b8e74867402274687491e5978ba4a6ded94e9f5ecc3e364024e5683e   4 hours ago         Running             calico-node         1                   cef42271f35de       calico-node-l6v9m
47937ad871734       b690f5f0a2d535cee5e08631aa508fef339c43bb91d5b1f7d77a1a05cea021a8   4 hours ago         Running             nginxstateful       0                   6b2be435a70e1       nginx-stateful-nginxstateful-0
49fec7e6c6492       342a759d88156b4f56ba522a1aed0e3d32d72542545346b40877f6583bebe05f   4 hours ago         Running             kube-proxy          1                   5a3fdc53d38d7       kube-proxy-wjcdf



root@worker-node02:/home/vagrant# crictl ps
CONTAINER           IMAGE                                                              CREATED             STATE               NAME                ATTEMPT             POD ID              POD
717bcad0d4081       b690f5f0a2d535cee5e08631aa508fef339c43bb91d5b1f7d77a1a05cea021a8   5 hours ago         Running             nginxdeployment     0                   0d5d528f41cdc       nginx-deployment-nginxdeployment-7c96647cbb-656pl
3ba96a1244e34       08616d26b8e74867402274687491e5978ba4a6ded94e9f5ecc3e364024e5683e   17 hours ago        Running             calico-node         0                   2b5641692fbb0       calico-node-vrrcd
a9a5caf4b7898       342a759d88156b4f56ba522a1aed0e3d32d72542545346b40877f6583bebe05f   17 hours ago        Running             kube-proxy          0                   cd9fc48065c9a       kube-proxy-nfw6s
```