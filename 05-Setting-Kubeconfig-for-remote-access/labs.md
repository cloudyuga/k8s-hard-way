## The Admin Kubernetes Configuration File [Follow these steps on workstation where we have genrated certificates and keys]

Each kubeconfig requires a Kubernetes API Server to connect to. To support high availability the IP address assigned to the external load balancer fronting the Kubernetes API Servers will be used.

- Export Load Balancer IP.

```command
export LOADBALANCER_IP=
```

- Set a context from a workstation where we have created certificates and keys.

```command

{
  KUBERNETES_PUBLIC_ADDRESS=${LOADBALANCER_IP}

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

```command
kubectl get componentstatuses
```
```
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   {"health":"true"}
etcd-1               Healthy   {"health":"true"}
```

- List the nodes in the remote Kubernetes cluster:

```command
kubectl get nodes
```
```
NAME       STATUS   ROLES    AGE   VERSION
worker-1   Ready    <none>   4m    v1.10.6
worker-2   Ready    <none>   3m    v1.10.6
```



## Apply the DNS. [On Master node]

```command
kubectl create -f https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/deployments/kube-dns.yaml
```


- Cluster info.

```command
kubectl cluster-info
```
```
Kubernetes master is running at https://<Public IP>:6443
KubeDNS is running at https://<Public IP>:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
