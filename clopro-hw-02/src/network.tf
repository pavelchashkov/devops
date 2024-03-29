locals {
  network_name       = "network-netology"
  public_subnet_name = "public"
}

resource "yandex_vpc_network" "network" {
  name = local.network_name
}

resource "yandex_vpc_subnet" "public" {
  name           = local.public_subnet_name
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.network.id
}
