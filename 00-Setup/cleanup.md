
- We are asuming your public keys and private keys are located at `~/.ssh/id_rsa.pub` and `~/.ssh/id_rsa`


## Deleting Nodes from DigitalOcean.

- Clone the Repository
``` 
$ git clone https://github.com/cloudyuga/k8s-hard-way.git
```

- Go to the Terrafrom  delete script directory.
```
$ cd k8s-hard-way/00-Setup/
```

- Get a Fingerprint of Your SSH public key.(This SSH key must be linked with DigitalOcean)
```
$ ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}'
MD5:dd:d1:b7:0f:6d:30:c0:be:ed:ae:c7:b9:b8:4a:df:5e
```

- Export a Fingerprint shown in above output.
```
$ export FINGERPRINT=dd:d1:b7:0f:6d:30:c0:be:ed:ae:c7:b9:b8:4a:df:5e
```

- Export your DO Personal Access Token.
```
$ export TOKEN=##########<Your Digital Ocean Personal Access Token>##########
```


### Delete Cluster.

```
$ ./destroy.sh
```
