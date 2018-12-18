resource "digitalocean_droplet" "master-1" {
    name = "master-1"
    image = "ubuntu-16-04-x64"
    size = "${var.size}"
    region = "${var.region}"
    ipv6 = true
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

}

resource "digitalocean_droplet" "master-2" {
    name = "master-2"
    image = "ubuntu-16-04-x64"
    size = "${var.size}"
    region = "${var.region}"
    ipv6 = true
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]


}

resource "digitalocean_droplet" "worker-1" {
    name = "worker-1"
    image = "ubuntu-16-04-x64"
    size = "${var.size}"
    region = "${var.region}"
    ipv6 = true
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
}

resource "digitalocean_droplet" "worker-2" {
    name = "worker-2"
    image = "ubuntu-16-04-x64"
    size = "${var.size}"
    region = "${var.region}"
    ipv6 = true
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
   
}
