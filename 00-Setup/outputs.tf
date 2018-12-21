output "Master1_Node_addresses" { 
 value = "${digitalocean_droplet.master-1.ipv4_address}"
}

output "Master1_PrivateIP_addresses" { 
 value = "${digitalocean_droplet.master-1.ipv4_address_private}"
}
output "Master2_Node_addresses" { 
 value = "${digitalocean_droplet.master-2.ipv4_address}"
}

output "Master2_PrivateIP_addresses" { 
 value = "${digitalocean_droplet.master-2.ipv4_address_private}"
}

output "Worker1_Node_addresses" { 
 value = "${digitalocean_droplet.worker-1.ipv4_address}"
}
output "Worker1_PrivateIP_addresses" { 
 value = "${digitalocean_droplet.worker-1.ipv4_address_private}"
}
output "Worker2_Node_addresses" { 
 value = "${digitalocean_droplet.worker-2.ipv4_address}"
}
output "Worker2_PrivateIP_addresses" { 
 value = "${digitalocean_droplet.worker-2.ipv4_address_private}"
}

provisioner "local-exec" {
    command = "MASTER_1_PUBLIC_IP=${digitalocean_droplet.master-1.ipv4_address} >> ${terraform.workspace}.txt",
    command = "MASTER_1_PRIVATE_IP=${digitalocean_droplet.master-1.ipv4_address_private} >> ${terraform.workspace}.txt",
    command = "MASTER_2_PUBLIC_IP=${digitalocean_droplet.master-2.ipv4_address} >> ${terraform.workspace}.txt",
    command = "MASTER_2_PRIVATE_IP=${digitalocean_droplet.master-2.ipv4_address_private} >> ${terraform.workspace}.txt",
    command = "WORKER_1_PUBLIC_IP=${digitalocean_droplet.worker-1.ipv4_address} >> ${terraform.workspace}.txt",
    command = "WORKER_1_PRIVATE_IP=${digitalocean_droplet.worker-1.ipv4_address_private} >> ${terraform.workspace}.txt",
    command = "WORKER_2_PUBLIC_IP=${digitalocean_droplet.worker-2.ipv4_address} >> ${terraform.workspace}.txt",
    command = "WORKER_2_PRIVATE_IP=${digitalocean_droplet.worker-2.ipv4_address_private} >> ${terraform.workspace}.txt"
  }















