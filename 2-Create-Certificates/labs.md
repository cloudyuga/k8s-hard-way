Kubernetes by Hard way

## Prerequisites

- 4 `Ubuntu 16.04 x64` node running with `Private IP` on Digital Ocean.

- List of the  Nodes.

```preventcopy
Node        IP                          Private IP
master-1  <MASTER_1_PUBLIC_IP>         <MASTER_1_PRIVATE_IP>
Master-2  <MASTER_2_PUBLIC_IP>         <MASTER_2_PRIVATE_IP>
worker-1  <WORKER_1_PUBLIC_IP>         <WORKER_1_PRIVATE_IP>
worker-2  <WORKER_2_PUBLIC_IP>         <WORKER_2_PRIVATE_IP>
```

- Install `cfssl` on the machine [Workstation] from where you can access all these nodes. The cfssl and cfssljson command line utilities will be used to provision a PKI Infrastructure and generate TLS certificates.




```command
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
mv cfssl_linux-amd64 cfssl
mv cfssljson_linux-amd64 cfssljson
export $PATH=PATH:`pwd`
```


## Certificates and Keys.
### CA




```command
{

cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

}
```

### Client and Server Certificates

In this section you will generate client and server certificates for each Kubernetes component and a client certificate for the Kubernetes `admin` user.

#### The Admin Client Certificate

- Generate the `admin` client certificate and private key:




```command
{

cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:master-0s",
      "OU": "Kubernetes The Hard Way",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin

}
```

### The Kubelet Client Certificates

Kubernetes uses a [special-purpose authorization mode](https://kubernetes.io/docs/admin/authorization/node/) called Node Authorizer, that specifically authorizes API requests made by [Kubelets](https://kubernetes.io/docs/concepts/overview/components/#kubelet). In order to be authorized by the Node Authorizer, Kubelets must use a credential that identifies them as being in the `system:nodes` group, with a username of `system:node:<nodeName>`. In this section you will create a certificate for each Kubernetes worker node that meets the Node Authorizer requirements.

- Generate a certificate and private key for each Kubernetes worker node:

### Generate a certificate and private key for Kubernetes worker-1




```command
cat > worker-1-csr.json <<EOF
{
  "CN": "system:node:worker-1",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Karnataka"
    }
  ]
}
EOF


cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=worker-1,${WORKER_1_PUBLIC_IP},${WORKER_1_PRIVATE_IP} \
  -profile=kubernetes \
  worker-1-csr.json | cfssljson -bare worker-1 
```

### Generate a certificate and private key for Kubernetes worker-2




```command
cat > worker-2-csr.json <<EOF
{
  "CN": "system:node:worker-2",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Karnataka"
    }
  ]
}
EOF


cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=worker-2,${WORKER_2_PUBLIC_IP},${WORKER_2_PRIVATE_IP} \
  -profile=kubernetes \
  worker-2-csr.json | cfssljson -bare worker-2

```

### The Controller Manager Client Certificate

- Generate the `kube-controller-manager` client certificate and private key:




```command
{

cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes The Hard Way",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

}
```

### The Kube Proxy Client Certificate

- Generate the `kube-proxy` client certificate and private key:




```command
{

cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

}
```

### The Scheduler Client Certificate

- Generate the `kube-scheduler` client certificate and private key:




```command
{

cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes The Hard Way",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

}
```

### The Kubernetes API Server Certificate
`KUBERNETES_PUBLIC_ADDRESS=` is IP address of Load Balancer

- Generate the Kubernetes API Server certificate and private key:




```command

{

KUBERNETES_PUBLIC_ADDRESS=${LOADBALANCER_IP}


cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,${MASTER_1_PRIVATE_IP},${MASTER_2_PRIVATE_IP},${MASTER_1_PUBLIC_IP},${MASTER_2_PUBLIC_IP},${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

}
```

### The Service Account Key Pair

The Kubernetes Controller Manager leverages a key pair to generate and sign service account tokens as describe in the [managing service accounts](https://kubernetes.io/docs/admin/service-accounts-admin/) documentation.

- Generate the `service-account` certificate and private key:




```command
{

cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account

}
```

### Distribute the Client and Server Certificates

- Copy the appropriate certificates and private keys to each worker instance:

- To worker1




```command

 scp ca.pem worker-1-key.pem worker-1.pem root@${WORKER_1_PUBLIC_IP}:~/

```

- To worker2




```command
 scp ca.pem worker-2-key.pem worker-2.pem root@${WORKER_2_PUBLIC_IP}:~/
```

## Generating Kubernetes Configuration Files for Authentication

### Client Authentication Configs

In this section you will generate kubeconfig files for the `controller manager`, `kubelet`, `kube-proxy`, and `scheduler` clients and the `admin` user.



#### The kubelet Kubernetes Configuration File

When generating kubeconfig files for Kubelets the client certificate matching the Kubelet's node name must be used. This will ensure Kubelets are properly authorized by the Kubernetes [Node Authorizer](https://kubernetes.io/docs/admin/authorization/node/).

- Generate a kubeconfig file for each worker node:




```command
{
KUBERNETES_PUBLIC_ADDRESS=${LOADBALANCER_IP}

for instance in worker-1 worker-2; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.pem \
    --client-key=${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done
}

```


#### The kube-proxy Kubernetes Configuration File

- Generate a kubeconfig file for the `kube-proxy` service:




```command
{
  KUBERNETES_PUBLIC_ADDRESS=${LOADBALANCER_IP}
  
  
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.pem \
    --client-key=kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
}

```

### The kube-controller-manager Kubernetes Configuration File

- Generate a kubeconfig file for the `kube-controller-manager` service:




```command
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.pem \
    --client-key=kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
}
```

### The kube-scheduler Kubernetes Configuration File

- Generate a kubeconfig file for the `kube-scheduler` service:




```command
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.pem \
    --client-key=kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
}
```


### The admin Kubernetes Configuration File

- Generate a kubeconfig file for the `admin` user:




```command
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig
}
```

### Distribute the Kubernetes Configuration Files

Copy the appropriate `kubelet` and `kube-proxy` kubeconfig files to each worker instance:

- worker-1




```command
 scp worker-1.kubeconfig kube-proxy.kubeconfig root@${WORKER_1_PUBLIC_IP}:~/
```

- worker-2




```command
 scp worker-2.kubeconfig kube-proxy.kubeconfig root@${WORKER_2_PUBLIC_IP}:~/
```


## Generating the Data Encryption Config and Key

Kubernetes stores a variety of data including cluster state, application configurations, and secrets. Kubernetes supports the ability to [encrypt](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data) cluster data at rest.

In this lab you will generate an encryption key and an [encryption config](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#understanding-the-encryption-at-rest-configuration) suitable for encrypting Kubernetes Secrets.

### The Encryption Key

- Generate an encryption key:




```command
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
```

### The Encryption Config File

- Create the `encryption-config.yaml` encryption config file:




```command
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
```

### Distribute Master node certificates.

- For `master-1` node.




```command
scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem service-account-key.pem service-account.pem admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig encryption-config.yaml root@${MASTER_1_PUBLIC_IP}:~/.
```

- For `master-2` node.




```command
scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem service-account-key.pem service-account.pem admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig encryption-config.yaml root@${MASTER_2_PUBLIC_IP}:~/.
```
