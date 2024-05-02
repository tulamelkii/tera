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

resource "yandex_iam_service_account" "local" { 
   name        =  "local"
   folder_id   =  "b1g89cjo0roopb2d5s14"
   description =  "service account from folder k8s-terra"
}         
resource "yandex_resourcemanager_folder_iam_member" "admin" {
   folder_id   = "b1g89cjo0roopb2d5s14"
   role        = "admin"
   member      = "serviceAccount:${ yandex_iam_service_account.local.id }"
   depends_on  = [ yandex_iam_service_account.local ]
 }

resource "yandex_vpc_address" "vpc_k8s_pub_ip" {
   name        = "pubip"
   folder_id   = "b1g89cjo0roopb2d5s14"
   external_ipv4_address {
     zone_id   = "ru-central1-a"
  }
}
resource "yandex_vpc_network" "vpc_k8s_net" {
   folder_id   = "b1g89cjo0roopb2d5s14"
   name        = "netk8s"
   description = "virtual network cluster k8s for ru-central1-a"
}

resource "yandex_vpc_subnet" "vpc_k8s_sub" {
   folder_id      = "b1g89cjo0roopb2d5s14"
   name           = "subk8s"
   description    = "virtual subnet cluster k8s for ru-central1-a"
   v4_cidr_blocks = ["192.168.1.0/24"]
   network_id     = "${ yandex_vpc_network.vpc_k8s_net.id }"
   zone           = "ru-central1-a"
}
#
### Instance group control
##
resource "yandex_compute_instance_group" "contral" {
  folder_id           = "b1g89cjo0roopb2d5s14"
  name                = "local"
  service_account_id  = "${ yandex_iam_service_account.local.id }"
  depends_on          = [ yandex_resourcemanager_folder_iam_member.admin ]

instance_template {
   resources {
     memory = 2
     cores  = 2
   }
 
boot_disk {
  mode = "READ_WRITE"                
  initialize_params {
  image_id = "fd89nebr9a651021u19i"  
  size     = 15                      
   }
 }

network_interface {
   network_id     = "${ yandex_vpc_network.vpc_k8s_net.id }"
   subnet_ids     = ["${ yandex_vpc_subnet.vpc_k8s_sub.id }"]
   nat            =  true
   nat_ip_address = yandex_vpc_address.vpc_k8s_pub_ip.external_ipv4_address[0].address
  }

  metadata = {
  ssh-keys = "localadm:${file("/home/localadm/.ssh/id_rsa.pub")}"
   }
}

scale_policy {
  fixed_scale {
    size = 1
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

### Instance group Worker

resource "yandex_compute_instance_group" "worker" {
  folder_id           = "b1g89cjo0roopb2d5s14"
  name                = "worker"
  service_account_id  = "${ yandex_iam_service_account.local.id }"
  depends_on          = [ yandex_resourcemanager_folder_iam_member.admin ]

instance_template {
resources {
    memory = 2
    cores  = 2
   }

boot_disk {
  mode = "READ_WRITE"                
initialize_params {
  image_id = "fd89nebr9a651021u19i"  
  size     = 15                      
   }
 }

network_interface {
   network_id     = "${ yandex_vpc_network.vpc_k8s_net.id }"
   subnet_ids     = ["${ yandex_vpc_subnet.vpc_k8s_sub.id }"]
   nat            = true
   nat_ip_address = yandex_vpc_address.vpc_k8s_pub_ip.external_ipv4_address[0].address

  }

  metadata = {
  ssh-keys = "localadm:${file("/home/localadm/.ssh/id_rsa.pub")}"
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















