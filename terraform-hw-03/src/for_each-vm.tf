locals {
  vms = [
    {
      id = 1,
      name = "main",
      cpu = 4,
      core_fraction = 20,
      ram = 8,
      disk = 10,
    },
    {
      id = 2,
      name = "replica",
      cpu = 2,
      core_fraction = 5,
      ram = 4,
      disk = 5
    }
  ]
}

resource "yandex_compute_instance" "database" {
  for_each = {
    for vm in var.database_vms :
    vm.id => vm
  }

  depends_on = [yandex_compute_instance.web]

  name = each.value.name
  platform_id = "standard-v1"

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base_ubuntu.image_id
      type = "network-hdd"
      size = each.value.disk
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_pub_key_file)}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  allow_stopping_for_update = true
}