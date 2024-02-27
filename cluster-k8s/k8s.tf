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

resource "yandex_vpc_subnet" "vpc.k8s.subnet" {
         name  = "vpc.k8s.subnet"
   description = "subnet for cluster k8s"
v4_cidr_blocks = ["192.168.49.0/28"]
          zone = "ru-central1-a"
    network_id = yandex_vpc_network.default.id
}

resource "yandex_iam_service_account" "localadm" {
          name = "localadm"
  descriptions = "service account ks8"
}

resource "yandex_resourcemanager_folder_iam_member" "admin" {
     folder_id = "b1gahuuq85502ap2q4im" 
          role = "admin"
        member = 

resource "yandex_compute_instance_group" "control-group" {
          name = "control-group"
     folder_id = "b1gahuuq85502ap2q4im"
     
     
