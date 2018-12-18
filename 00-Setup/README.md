## Prerequisites.


- You Must have a DigitalOcean account and `Personal Access Token` must be generated on [DigitalOcean](https://www.digitalocean.com/docs/api/create-personal-access-token/).


## Tools

### Create SSH Keys.
```
$ ssh-keygen -t rsa

Generating public/private rsa key pair.
Enter file in which to save the key (~/.ssh/id_rsa): 
Created directory '~/.ssh/'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ~/.ssh/id_rsa.
Your public key has been saved in ~/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:lCVaexVBIwHo++NlIxccMW5b6QAJa+ZEr9ogAElUFyY root@3b9a273f18b5
The key's randomart image is:
+---[RSA 2048]----+
|++.E ++o=o*o*o   |
|o   +..=.B = o   |
|.    .* = * o    |
| .   =.o + *     |
|  . . o.S + .    |
|   . +.    .     |
|    . ... =      |
|        o= .     |
|       ...       |
+----[SHA256]-----+

```

- You must link above created SSH key to [DigitalOcean] For that follow these [guidelines](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/create-with-openssh/)

### Install Terraform

- Download [Terraform binary](https://www.terraform.io/intro/getting-started/install.html) and add it to PATH.

```
apt install unzip
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip
mv terraform /usr/bin/.
terraform version
```
- We are asuming your public keys and private keys are located at `~/.ssh/id_rsa.pub` and `~/.ssh/id_rsa`


## Create Nodes for Kubernetes cluster on DigitalOcean.

- Clone the Repository
``` 
$ git clone https://github.com/cloudyuga/k8s-hard-way.git
```

- Go to the Terrafrom script directory.
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

- Now take a look at the directory.
```
$ ls
cluster.tf  destroy.sh  outputs.tf  provider.tf  script.sh
```
- Simply run the script.
```
./script.sh
```


### Delete Cluster.

```
$ ./destroy.sh
```
