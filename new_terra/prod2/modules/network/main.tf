terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_vpc_network" "vpc_k8s_net" {
  folder_id   = var.folder_id
  name        = var.name_vpc
  description = "virtual network cluster k8s for ru-central1-a"
}


resource "yandex_vpc_subnet" "vpc_k8s_sub" {
  folder_id      = var.folder_id
  name           = var.name_vpc
  description    = "virtual subnet cluster k8s for ru-central1-a"
  v4_cidr_blocks = var.v4_cidr_blocks 
  network_id     = var.network_id
  zone           = var.zones

}


