# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  # default = "{{env `YC_DEVOPS_NETOLOGY_CLOUD_ID`}}"
  type = string
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  # default = "{{env `YC_DEVOPS_NETOLOGY_DEFAULT_FOLDER_ID`}}"
  type = string
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "img_base" {
  # default = "${var.img_base}"
  type = string
}

variable "subnet_id" {
  type = string
}
