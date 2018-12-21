## Bootstrapping the etcd Cluster [On each master node]

Kubernetes components are stateless and store cluster state in [etcd](https://github.com/coreos/etcd). In this lab you will bootstrap a two node etcd cluster and configure it for high availability and secure remote access. 


### Download and Install the etcd Binaries on both `master-1` and `master-2` nodes.

- Do SSH login to `master-1` and `master-2` node. 
- Download the official etcd release binaries from the [coreos/etcd](https://github.com/coreos/etcd) GitHub project:

```command
wget -q --show-progress --https-only --timestamping \
  "https://github.com/coreos/etcd/releases/download/v3.3.5/etcd-v3.3.5-linux-amd64.tar.gz"
```

- Extract and install the `etcd` server and the `etcdctl` command line utility:

```command
{
  tar -xvf etcd-v3.3.5-linux-amd64.tar.gz
  sudo mv etcd-v3.3.5-linux-amd64/etcd* /usr/local/bin/
}
```

### Configure the etcd Server on both `master-1` and `master-2` 

```command
{
  sudo mkdir -p /etc/etcd /var/lib/etcd
  sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/
}
```

- Export Internal IP of Master1 and Master2 on both nodes.

```command
export MASTER_1_PRIVATE_IP=
```

```command
export MASTER_2_PRIVATE_IP=
```

- Export Load Balancer IP.

```command
export LOADBALANCER_IP=
```

- On `master-1` node, Create the `etcd.service` systemd file:


```command
{

ETCD_NAME=$(hostname -s)


cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${MASTER_1_PRIVATE_IP}:2380 \\
  --listen-peer-urls https://${MASTER_1_PRIVATE_IP}:2380 \\
  --listen-client-urls https://${MASTER_1_PRIVATE_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${MASTER_1_PRIVATE_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster master-1=https://${MASTER_1_PRIVATE_IP}:2380,master-2=https://${MASTER_2_PRIVATE_IP}:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

}
```


- On `master-2` node, Create the `etcd.service` systemd file:


- Create the `etcd.service` systemd file:

```command
{
ETCD_NAME=$(hostname -s)
INTERNAL_IP=<MASTER_2_PRIVATE_IP>

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${MASTER_2_PRIVATE_IP}:2380 \\
  --listen-peer-urls https://${MASTER_2_PRIVATE_IP}:2380 \\
  --listen-client-urls https://${MASTER_2_PRIVATE_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${MASTER_2_PRIVATE_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster master-1=https://${MASTER_1_PRIVATE_IP}:2380,master-2=https://${MASTER_2_PRIVATE_IP}:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

}

```

### Start the ETCD Services on both `master-1` and `master-2` .

```command
{
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
}

```

### Verification

- List the etcd cluster members:

```command
sudo ETCDCTL_API=3 etcdctl member list \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem
```
```
102a13d1003e5d5a, started, master-2, https://10.135.86.233:2380, https://10.135.86.233:2379
f5ca186f2ed6cf38, started, master-1, https://10.135.86.233:2380, https://10.135.86.233:2379

```
