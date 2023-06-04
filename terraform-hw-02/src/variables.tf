###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "compute_image" {
  type = string
  default = "ubuntu-2004-lts"
  description = "Base compute image"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCEScrYOLGybAD8NildiKOKzCB6IlIHk04l2O1kMVa2CV1HTHJeoYaUm2UmOaoLWBwuOlQZCnxPV6WGYwmQoWCJex+AGs0ea3uy+Y66z3VWK/Q8xXbsinmYJb7Rmlx2eztf+T4HhkvHatfwJcYh01JVfwuaYOS83drV8+YLzM44XLcfu+oxqxhg16lzSWGN0Vz+OhGdGDZaoivNwQOYqSjkBat6QsdigDzzCaNZZUAnGQDo10Jedvx+w5Fao/i6k8rfdQbycD8euruMfeeSOagMztyc5UCh1+NDtJS8OxRSVzXr5uz7SbGjSoJb8fgsf4vvBGSy3Muez7TvA6Thw2X Pavel@Pavel-PC"
  description = "ssh-keygen -t ed25519"
}
