locals {
  subnet_public_name  = "public"
  subnet_private_name = "private"
  vm_nat_name         = "nat-vm"
  vm_public_name      = "public-vm"
  vm_private_name     = "private-vm"
}

# Создание VPC

resource "yandex_vpc_network" "netology" {
  name = var.vpc_name
}

# Создание подсетей

resource "yandex_vpc_subnet" "public" {
  name           = local.subnet_public_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  name           = local.subnet_private_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

# Создание образов

resource "yandex_compute_image" "nat-instance" {
  source_family = "nat-instance-ubuntu"
}

resource "yandex_compute_image" "ubuntu-1804-lts" {
  source_family = "ubuntu-1804-lts"
}

# Создание загрузочных дисков

resource "yandex_compute_disk" "boot-disk-nat" {
  name     = "boot-disk-nat"
  type     = "network-hdd"
  zone     = var.default_zone
  size     = "20"
  image_id = yandex_compute_image.nat-instance.id
}

resource "yandex_compute_disk" "boot-disk-public-vm" {
  name     = "boot-disk-public-vm"
  type     = "network-hdd"
  zone     = var.default_zone
  size     = "20"
  image_id = yandex_compute_image.ubuntu-1804-lts.id
}

resource "yandex_compute_disk" "boot-disk-private-vm" {
  name     = "boot-disk-private-vm"
  type     = "network-hdd"
  zone     = var.default_zone
  size     = "20"
  image_id = yandex_compute_image.ubuntu-1804-lts.id
}

# Создание ВМ NAT

resource "yandex_compute_instance" "nat-vm" {
  name        = local.vm_nat_name
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-nat.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    # security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
    nat = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.ssh_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }
}

# Создание ВМ ubuntu в public подсети

resource "yandex_compute_instance" "public-vm" {
  name        = local.vm_public_name
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-public-vm.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.ssh_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }
}

resource "yandex_compute_instance" "private-vm" {
  name        = local.vm_private_name
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-private-vm.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.ssh_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }
}

# Создание таблицы маршрутизации и статического маршрута

resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.netology.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-vm.network_interface.0.ip_address
  }
}
