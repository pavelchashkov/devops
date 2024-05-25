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

variable "default_subnet_zone" {
  type        = string
  default     = "ru-central1-d"
  description = "default subnet zone (https://cloud.yandex.ru/docs/overview/concepts/geo-scope)"
}

variable "subnet_zones" {
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"] # ru-central1-d выводится из эксплуатации
  description = "subnet zones (https://cloud.yandex.ru/docs/overview/concepts/geo-scope)"
}

variable "zone_cidrs" {
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  description = "zone cirds (https://cloud.yandex.ru/docs/overview/concepts/geo-scope)"
}

variable "service_account_name" {
  type        = string
  default     = "diplom-infra-sa"
  description = "service account name"
}

variable "vpc_name" {
  type        = string
  default     = "diplom-vpc-dev"
  description = "vpc name"
}

variable "ssh_user" {
  type        = string
  description = "ssh user"
}

variable "ssh_key_path" {
  type        = string
  description = "ssh key path"
}
