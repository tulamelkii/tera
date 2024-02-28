terraform {
  required_providers {
    yandex = {
    source = "yandex-cloud/yandex"
     }
} 
required_version = ">= 0.13"
  
}
provider "yandex" {
  zone = "ru-central1-a"
      }


resource "yandex_vpc_network" "network" {
  name        = "network"
  description = "virtual network cluster k8s for ru-central1-a"
      }

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  description    = "subnet for cluster k8s"
  v4_cidr_blocks = ["192.168.49.0/28"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
}

resource "yandex_iam_service_account" "tera" {
  name         = "tera"
  description  = "service account ks8"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id  = "b1gahuuq85502ap2q4im" 
  role       = "editor"
  member     = "serviceAccount:${yandex_iam_service_account.tera.id}"
  depends_on = [ yandex_iam_service_account.tera]
}

resource "yandex_compute_instance_group" "control" {
  name               = "control"
  folder_id          = "b1gahuuq85502ap2q4im"
  service_account_id = "${yandex_iam_service_account.tera.id}"
  depends_on         = [yandex_resourcemanager_folder_iam_member.editor] 
instance_template {
  resources {
  memory = 2
  cores  = 2
}
boot_disk {
  mode = "READ_WRITE"
initialize_params {
  image_id = "fd87e3vsemiab8q1tl0h"
  }
 } 
network_interface {
  network_id = "${yandex_vpc_network.network.id}"
  subnet_ids = ["${yandex_vpc_subnet.subnet.id}"]
#security_group_ids = ["list indeficater sec group"]
}      
}
scale_policy {
  fixed_scale {
    size = 2
    }
  }
allocation_policy {
  zones = ["ru-central1-a"]
  }
deploy_policy {
  max_unavailable = 1
  max_expansion   = 0
  }

}
