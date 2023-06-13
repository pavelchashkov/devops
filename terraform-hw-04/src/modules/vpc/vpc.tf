terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_vpc_network" "by_name" {
  name = var.vpc_name
  description = "resource yandex_vpc_network"
}

resource "yandex_vpc_subnet" "by_name" {
  name           = "${var.vpc_name}-${var.vpc_zone}"
  zone           = var.vpc_zone
  network_id     = yandex_vpc_network.by_name.id
  v4_cidr_blocks = var.vpc_v4_cidr_blocks
  description = "resource yandex_vpc_subnet"
}