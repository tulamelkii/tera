terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
   zone      = "ru-central1-a"
}

#resource "yandex_compute_disk" "disk" {
#  name       = "disk"
#  type       = "network-hdd"
#  zone       = "ru-central1-a"
#  size       = 10
#  block_size = 4096
#}
resource "yandex_compute_instance" "control-plane-1" {
  count       =   0
  name        =  "cp1"
  zone        =  "ru-central1-a"
 
resources {
  cores       =   2
  memory      =   2
   }

network_interface {
    subnet_id = "e9b2n74fbdi7c9q75vln"
    nat       = true
  }

boot_disk {
    initialize_params {
      image_id = "fd8an3flq975h3g61g2q"
    }
  }
metadata = {
    ssh-keys = "localadm:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDBw9XhGw0nRRX9BdJvoOixcRQsCIH2E22Y4yDYphDD localadm@DEB"
  }

}

#resource "yandex_vpc_network" "lab-net" {
#  name        = "lab-net"
#}
#resource "yandex_vpc_subnet" "subnet" {
#  name           = "subnet"
#  description    = "kuber network"
#  v4_cidr_blocks = ["10.128.0.0/24"]
#  zone           = "ru-central1-a"
#  network_id     = "e9b2n74fbdi7c9q75vln"
#}



