terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.92.0"
    }
  }
  required_version = ">=0.13"

  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "chashkov-tfstate-hw5"
    key                         = "terraform.tfstate"
    region                      = "ru-central1"
    #    access_key     = "..." #Только для примера! Не хардкодим секретные данные!
    #    secret_key     = "..." #Только для примера! Не хардкодим секретные данные!
    dynamodb_endpoint           = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gpi6bkakgcig2di2qd/etnobs5bqtjn8sjcjpsa"
    dynamodb_table              = "tflock-develop"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

module "vpc_dev" {
  source             = "./modules/vpc"
  vpc_name           = "develop"
  vpc_zone           = "ru-central1-a"
  vpc_v4_cidr_blocks = ["10.0.1.0/24"]
}

# tflint-ignore: terraform_required_providers
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars     = {
    ssh_key = file(var.ssh_pub_key_file)
  }
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=1.0.0"
  env_name       = "develop"
  network_id     = module.vpc_dev.vpc_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [module.vpc_dev.subnet_id]
  instance_name  = "web"
  instance_count = 2
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }
}

