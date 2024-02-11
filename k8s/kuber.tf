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

resource "yandex_compute_instance" "control-plane-1" {
  name        =  "cp1"
  zone        =  "ru-central1-a"

resources {
  cores       =   2
  memory      =   2
   }

network_interface {
    subnet_id = "e2lhej6g035n59bnju7i"
  }

metadata     = {
    ssh-keys = "localadm:${file("~/.ssh/id_ed25519.pub")}"
  }

}
resource "yandex_compute_disk" "default" {
  name        =  "default"
  type        =  "network-hdd"
  zone        =  "ru-central1-a"
  size        =  "30"
  image_id    =  "fd89nebr9a651021u19i"
 }


