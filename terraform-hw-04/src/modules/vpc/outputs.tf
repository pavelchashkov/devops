output "vpc_id" {
  value = yandex_vpc_network.by_name.id
  description = "vpc_id"
}

output "subnet_id" {
  value = yandex_vpc_subnet.by_name.id
  description = "subnet_id"
}