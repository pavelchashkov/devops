resource "yandex_vpc_network" "dev" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "dev_subnets" {
  count          = 3
  name           = "subnet-${var.subnet_zones[count.index]}"
  zone           = var.subnet_zones[count.index]
  network_id     = yandex_vpc_network.dev.id
  v4_cidr_blocks = ["${var.zone_cidrs[count.index]}"]
}
