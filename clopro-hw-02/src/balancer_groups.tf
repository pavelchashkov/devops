locals {
  network_lb_group_name     = "network-lb-gr"
  application_lb_group_name = "app-lb-gr"
}

data "yandex_compute_image" "lamp_image" {
  family = "lamp"
}

# Network Load Balancer Group
resource "yandex_compute_instance_group" "network_lb_gr" {
  name                = local.network_lb_group_name
  folder_id           = var.folder_id
  service_account_id  = yandex_iam_service_account.sa.id
  deletion_protection = false

  load_balancer {
    target_group_name = local.network_lb_group_name
  }

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.lamp_image.id
        type     = "network-hdd"
        size     = "20"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = false
      ipv6       = false
    }

    network_settings {
      type = "STANDARD"
    }

    metadata = {
      user-data = <<EOF
#!/bin/bash
echo "<html><p>Netwrok Load Balancer</p><p>"`cat /etc/hostname`"</p><img src="https://storage.yandexcloud.net/${yandex_storage_object.main_cat.bucket}/${yandex_storage_object.main_cat.key}" alt="main_cat"></html>" > /var/www/html/index.html
EOF
      ssh-keys  = "${file("${var.ssh_key_path}")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 3
    max_expansion   = 0
    max_deleting    = 3
    max_creating    = 3
  }
}

# Application Load Balancer Group
resource "yandex_compute_instance_group" "app_lb_gr" {
  name                = local.application_lb_group_name
  folder_id           = var.folder_id
  service_account_id  = yandex_iam_service_account.sa.id
  deletion_protection = false

  application_load_balancer {
    target_group_name = local.application_lb_group_name
  }

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.lamp_image.id
        type     = "network-hdd"
        size     = "20"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = false
      ipv6       = false
    }

    network_settings {
      type = "STANDARD"
    }

    metadata = {
      user-data = <<EOF
#!/bin/bash
echo "<html><p>Netwrok Load Balancer</p><p>"`cat /etc/hostname`"</p><img src="https://storage.yandexcloud.net/${yandex_storage_object.main_cat.bucket}/${yandex_storage_object.main_cat.key}" alt="main_cat"></html>" > /var/www/html/index.html
EOF
      ssh-keys  = "${file("${var.ssh_key_path}")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 3
    max_expansion   = 0
    max_deleting    = 3
    max_creating    = 3
  }
}
