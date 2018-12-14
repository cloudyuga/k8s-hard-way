## The Admin Kubernetes Configuration File [Follow these steps on workstation where we have genrated certificates and keys]

Each kubeconfig requires a Kubernetes API Server to connect to. To support high availability the IP address assigned to the external load balancer fronting the Kubernetes API Servers will be used.


- Set a context from a workstation where we have created certificates and keys.

```

{
  KUBERNETES_PUBLIC_ADDRESS=<LoadBalancer-Public-IP>

  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --embed-certs=true

  kubectl config set-context kubernetes-the-hard-way \
    --cluster=kubernetes-the-hard-way \
    --user=admin

  kubectl config use-context kubernetes-the-hard-way
}
```

- Check the health of the remote Kubernetes cluster:

```
$ kubectl get componentstatuses
```
> output
```
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   {"health":"true"}
```

- List the nodes in the remote Kubernetes cluster:

```
$ kubectl get nodes
```
> output
```
NAME       STATUS    ROLES     AGE       VERSION
worker-1   Ready     <none>    1m        v1.10.2
worker-2   Ready     <none>    1m        v1.10.2
```



## Apply the DNS. [On Master node]

```
$ kubectl create -f https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/deployments/kube-dns.yaml
```


- Cluster info.

```
$ kubectl cluster-info
```
> output
```
Kubernetes master is running at https://<Public IP>:6443
KubeDNS is running at https://<Public IP>:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
