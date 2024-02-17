# Pod list
```
vagrant@master-node:~$ kubectl get pods -o wide
NAME                                                           READY   STATUS    RESTARTS   AGE    IP           NODE            NOMINATED NODE   READINESS GATES
nginx-chaos-deployment-nginxchaosdeployment-6459f9b6bb-2l46z   2/2     Running   0          49s    10.0.1.199   worker-node01   <none>           <none>
nginx-deployment-nginxdeployment-7c96647cbb-5xv7h              1/1     Running   0          133m   10.0.1.219   worker-node01   <none>           <none>
nginx-stateful-nginxstateful-0                                 1/1     Running   0          133m   10.0.2.5     worker-node02   <none>           <none>
```

# Scenario1:
Without policy backend can be reached from both frontend and agent-of-chaos
