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
  default     = "ru-central1-d"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "service_account_name" {
  type        = string
  default     = "service-account"
  description = "service account name"
}

variable "vpc_name" {
  type        = string
  default     = "netology-clopro"
  description = "VPC network & subnet name"
}

###ssh vars

variable "ssh_user" {
  type        = string
  description = "ssh user"
}

variable "ssh_key_path" {
  type        = string
  description = "ssh key path"
}
