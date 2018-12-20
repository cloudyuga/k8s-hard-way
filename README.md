# k8s-hard-way on DO

### Cluster Details

# Cluster Details

Kubernetes The Hard Way guides you through bootstrapping a highly available Kubernetes cluster with end-to-end encryption between components and RBAC authentication. The kubernetes cluster will be created with following specifications:

* [Kubernetes](https://github.com/kubernetes/kubernetes) v1.10.6
* [containerd Container Runtime](https://github.com/containerd/containerd) v1.1.0
* [CNI Container Networking](https://github.com/containernetworking/cni) 0.7.1
* [etcd](https://github.com/coreos/etcd) v3.3.5
* [KubeDNS](https://github.com/kubernetes/dns) 



### Labs

* [Provisioning Compute Resources](00-Setup/README.md)
* [Provisioning the CA and Generating TLS Certificates](01-Create-Certificates/labs.md)
* [Bootstrapping the etcd Cluster](02-BootStrap-ETCD-Cluster-On-Master-Node/labs.md)
* [Bootstrapping the Kubernetes Control Plane](03-Bootstrap-Control-plane-Master-Node/labs.md)
* [Bootstrapping the Kubernetes Worker Nodes](04-Bootstrap-Worker-Node/labs.md)
* [Configuring kubectl for Remote Access](05-Setting-Kubeconfig-for-remote-access/labs.md)
* [Smoke Test](06-Smoke-test/labs.md)
* [Cleaning Up](00-Setup/cleanup.md)
