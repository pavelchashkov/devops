resource "yandex_compute_image" "ubuntu-1804-lts" {
  source_family = "ubuntu-1804-lts"
}

resource "yandex_compute_instance" "k8s-infra" {
  count       = 3
  name        = "k8s-node-${count.index}"
  hostname    = "k8s-node-${count.index}"
  platform_id = "standard-v3"
  zone        = var.subnet_zones[count.index]

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu-1804-lts.id
      type     = "network-hdd"
      size     = 80
    }
  }


  network_interface {
    subnet_id = yandex_vpc_subnet.dev_subnets[count.index].id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.ssh_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }
}


output "control_plane_public_ip" {
  description = "Public IP addresses for control-plane"
  value       = yandex_compute_instance.k8s-infra[0].network_interface.0.nat_ip_address
}

output "nodes_public_ips" {
  description = "Public IP addresses for worder-nodes"
  value       = yandex_compute_instance.k8s-infra.*.network_interface.0.nat_ip_address
}

output "nodes_private_ips" {
  description = "Private IP addresses for worker-nodes"
  value       = yandex_compute_instance.k8s-infra.*.network_interface.0.ip_address
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
      nodes_public_ips = yandex_compute_instance.k8s-infra.*.network_interface.0.nat_ip_address,
      user             = var.ssh_user
    }
  )
  filename = "inventory.yaml"
}
