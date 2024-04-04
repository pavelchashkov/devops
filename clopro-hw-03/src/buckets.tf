locals {
  secure_bucket_name = "chashkov.ps-clopro-hw-03.secure"
  web_bucket_name    = "chashkov.ps-clopro-hw-03.com"
  img_object_name    = "main-cat.jpg"
  index_object_name  = "index.html"
}

// Creating a secure bucket using the key
resource "yandex_storage_bucket" "secure" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.secure_bucket_name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.netology.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_bucket" "web" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.web_bucket_name

  anonymous_access_flags {
    read = true
    list = true
  }
}

resource "yandex_storage_object" "secure_main_cat" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.secure.bucket
  key        = local.img_object_name
  source     = "./main-cat.jpg"
  acl        = "public-read"
}

resource "yandex_storage_object" "web_main_cat" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.web.bucket
  key        = local.img_object_name
  source     = "./main-cat.jpg"
  acl        = "public-read"
}

resource "yandex_storage_object" "web_index" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.web.bucket
  key        = local.index_object_name
  source     = "./index.html"
  acl        = "public-read"
}
