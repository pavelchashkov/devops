locals {
  bucket_name     = "chashkov.ps-clopro-hw-02"
  img_object_name = "main-cat.jpg"
}

// Creating a bucket using the key
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
}

resource "yandex_storage_object" "main_cat" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.test.bucket
  key        = local.img_object_name
  source     = "./main-cat.jpg"
  acl        = "public-read"
}
