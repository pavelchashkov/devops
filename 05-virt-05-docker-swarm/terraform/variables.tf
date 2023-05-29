# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
#  default = "b1gu1gt5nqi6lqgu3t7s"
  type = string
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
#  default = "b1gaec42k169jqpo02f7"
  type = string
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "img_base" {
#  default = "fd884f65mo7hpqd0suh4"
  type = string
}
