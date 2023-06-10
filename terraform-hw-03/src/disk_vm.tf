resource "yandex_compute_disk" "disks" {
  count = 3
  name = "disk-${count.index+1}"
  type = "network-hdd"
  size = 1
}

resource "yandex_compute_instance" "storage" {
  count = 1
  name = "storage-${count.index+1}"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base_ubuntu.image_id
      type = "network-hdd"
      size = 5
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks
    iterator = disk
    content {
      disk_id = disk.value.id
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