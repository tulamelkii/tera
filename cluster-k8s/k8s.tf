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

resource "yandex_vpc_network" "default" {
        name   = "vpc.k8s.network"
   description = "virtual network cluster k8s for ru-central1-a"

       }

resource "yandex_vpc_subnet" "cluster-subnet-a" {
         name  = "vpc.k8s.subnet"
   description = "subnet for cluster k8s"
v4_cidr_blocks = ["192.168.49.0/28"]
          zone = "ru-central1-a"
    network_id = yandex_vpc_network.default.id
}

