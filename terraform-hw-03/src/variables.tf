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
  description = "VPC network&subnet name"
}

variable "base_compute_image" {
  type = string
  default = "ubuntu-2004-lts"
  description = "Base compute image"
}

variable "vm_web_user" {
  type = string
  default = "ubuntu"
}

variable "ssh_pub_key_file" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "database_vms" {
  type = list(object({
    id = number
    name = string
    cpu = number
    core_fraction = number
    ram = number
    disk = number
  }))
  default = [
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