resource "digitalocean_droplet" "master-1" {
    name = "master-1"
    image = "ubuntu-16-04-x64"
    size = "${var.size}"
    tags = ["${var.tag}"]
    region = "${var.region}"
    ipv6 = true
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
   provisioner "local-exec" {
    command = "echo 'export MASTER_1_PUBLIC_IP=${digitalocean_droplet.master-1.ipv4_address}' >> address.txt"
   }
   provisioner "local-exec" {
    command = "echo 'export MASTER_1_PRIVATE_IP=${digitalocean_droplet.master-1.ipv4_address_private}' >> address.txt"
   }
}

resource "digitalocean_droplet" "master-2" {
    name = "master-2"
    image = "ubuntu-16-04-x64"
    size = "${var.size}"
    tags = ["${var.tag}"]
    region = "${var.region}"
    ipv6 = true
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    provisioner "local-exec" {
    command = "echo 'export MASTER_2_PUBLIC_IP=${digitalocean_droplet.master-2.ipv4_address}' >> address.txt"
    } 
    provisioner "local-exec" {
    command = "echo 'export MASTER_2_PRIVATE_IP=${digitalocean_droplet.master-2.ipv4_address_private}' >> address.txt"
    }
}

resource "digitalocean_droplet" "worker-1" {
    name = "worker-1"
    image = "ubuntu-16-04-x64"
    size = "${var.size}"
    tags = ["${var.tag}"]
    region = "${var.region}"
    ipv6 = true
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

	provisioner "local-exec" {
	    command = "echo 'export WORKER_1_PUBLIC_IP=${digitalocean_droplet.worker-1.ipv4_address}' >> address.txt"
	 } 
	provisioner "local-exec" {
	    command = "echo 'export WORKER_1_PRIVATE_IP=${digitalocean_droplet.worker-1.ipv4_address_private}' >> address.txt"
	 }
}

resource "digitalocean_droplet" "worker-2" {
    name = "worker-2"
    image = "ubuntu-16-04-x64"
    size = "${var.size}"
    tags = ["${var.tag}"]
    region = "${var.region}"
    ipv6 = true
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
 	 provisioner "local-exec" {
	    command = "echo 'export WORKER_2_PUBLIC_IP=${digitalocean_droplet.worker-2.ipv4_address}' >> address.txt"
	 }
	 provisioner "local-exec" {
	    command = "echo 'export WORKER_2_PRIVATE_IP=${digitalocean_droplet.worker-2.ipv4_address_private}' >> address.txt"
	  }
  
}

