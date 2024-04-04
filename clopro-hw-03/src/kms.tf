locals {
  kms_name = "netology"
}


resource "yandex_kms_symmetric_key" "netology" {
  name              = local.kms_name
  description       = "netology clopro-hw-03 kms key"
  default_algorithm = "AES_128"
  rotation_period   = "4380h" // ~ 6 мес
}
