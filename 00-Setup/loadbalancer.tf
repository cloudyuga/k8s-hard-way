
resource "digitalocean_loadbalancer" "public" {
  name = "k8s-load"
  region = "${var.region}"

  forwarding_rule {
    entry_port = 6443
    entry_protocol = "tcp"

    target_port = 6443
    target_protocol = "tcp"

  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }

  droplet_tag = "${var.tag}"
}

