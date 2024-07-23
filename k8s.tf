terraform {
  required_providers {
  yandex = {
    source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.120"
}


provider "yandex" {
  zone = "ru-central1-a"
}

##########################################################

#resource "yandex_resourcemanager_folder" "terra" {
  #  cloud_id    = "b1gblbp7v441epoftcdg"
  #  name        = "terra"
  #  description = "folder from otus terraform"
  #}

#resource "yandex_iam_service_account" "iam-service" {
#  name        = "iam-service"
#  folder_id   = yandex_resourcemanager_folder.terra.id
#  description = "service account from folder k8s-terra"
#  depends_on  = [yandex_resourcemanager_folder.terra]
#}
#resource "yandex_resourcemanager_folder_iam_member" "admin" {
#  folder_id  = yandex_resourcemanager_folder.terra.id
#  role       = "admin"
#  member     = "serviceAccount:${yandex_iam_service_account.iam-service.id}"
#  depends_on = [yandex_iam_service_account.iam-service]
#}
#
######################create service-access and s3 storage #########################
#resource "yandex_iam_service_account_static_access_key" "access_key" {
#  service_account_id = yandex_iam_service_account.iam-service.id
#}
#
#resource "yandex_storage_bucket" "test" {
#  access_key            = yandex_iam_service_account_static_access_key.access_key.access_key
#  secret_key            = yandex_iam_service_account_static_access_key.access_key.secret_key
#  bucket                = "testk8s"
#  max_size              = 50000
#  default_storage_class = "STANDARD"
#  folder_id = yandex_resourcemanager_folder.terra.id
# 
#anonymous_access_flags {
#  read        = true
#  list        = true
#  config_read = true
#  }
#}
#
###################################################################################
#
#
#resource "yandex_vpc_network" "vpc_k8s_net" {
#  folder_id   = yandex_resourcemanager_folder.terra.id
#  name        = "netk8s"
#  description = "virtual network cluster k8s for ru-central1-a"
#}
#
#
#resource "yandex_vpc_subnet" "vpc_k8s_sub" {
#  folder_id      = yandex_resourcemanager_folder.terra.id
#  name           = "subk8s"
#  description    = "virtual subnet cluster k8s for ru-central1-a"
#  v4_cidr_blocks = ["192.168.2.0/28"]
#  network_id     = yandex_vpc_network.vpc_k8s_net.id
#  zone           = "ru-central1-a"
#}
#
#
#resource "local_file" "inventory" {
#depends_on = [yandex_compute_instance_group.control, yandex_compute_instance_group.worker]
#content = templatefile("${path.module}/templates/inventory.tpl",
#          {
#  control = yandex_compute_instance_group.control.instances[*].network_interface[0].nat_ip_address
#  worker = yandex_compute_instance_group.worker.instances[*].network_interface[0].nat_ip_address
#          }
#)
#filename = "${path.module}/ansible/inventory"
#
#    provisioner "local-exec" {
#    working_dir = "${path.module}/../ansible/"
#    command = "ansible-playbook -i inventory main.yaml"
#  }
#
#}
#
#
#
#
###############
#resource "yandex_vpc_security_group" "allow_ssh" {
#  name       = "allow-ssh"
#  network_id = yandex_vpc_network.vpc_k8s_net.id
#  folder_id  = yandex_resourcemanager_folder.terra.id
#
#
#  ingress {
#    protocol       = "tcp"
#    description    = "Allow SSH from anywhere"
#    from_port      = 22
#    to_port        = 22
#    v4_cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    protocol       = "tcp"
#    description    = "Allow all outbound traffic"
#    from_port      = 0
#    to_port        = 65535
#    v4_cidr_blocks = ["0.0.0.0/0"]
#  }
#}
################################## Instance group control#
#resource "yandex_compute_instance_group" "control" {
#  folder_id          = yandex_resourcemanager_folder.terra.id
#  name               = "control"
#  service_account_id = yandex_iam_service_account.iam-service.id
#  depends_on = [yandex_resourcemanager_folder_iam_member.admin]
#
#  instance_template {
#    name = "control-{instance.index}"
#    hostname = "control-{instance.index}"
#
#    resources {
#      memory = 2
#      cores  = 2
#    }
#
#    boot_disk {
#      mode = "READ_WRITE"
#      initialize_params {
#        image_id = "fd89nebr9a651021u19i"
#        size     = 15
#      }
#    }
#
#    network_interface {
#      network_id = yandex_vpc_network.vpc_k8s_net.id
#      subnet_ids = ["${yandex_vpc_subnet.vpc_k8s_sub.id}"]
#      nat        = true
#    }
#
#    metadata = {
#      ssh-keys  = "localadm:${file("/home/localadm/.ssh/git.pub")}"
#      # user-data = "${file("/home/localadm/github/tulamelkii_repo/kubernetes-logging/local.txt")}"
#
#    }
#  }
#
#  scale_policy {
#    fixed_scale {
#      size = 1
#    }
#  }
#
#  allocation_policy {
#    zones = ["ru-central1-a"]
#  }
#
#  deploy_policy {
#    max_unavailable = 1
#    max_expansion   = 0
#  }
#}
#resource "yandex_compute_instance_group" "worker" {
#  folder_id          = yandex_resourcemanager_folder.terra.id
#  name               = "worker"
#  service_account_id = yandex_iam_service_account.iam-service.id
#  depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
#
#  instance_template {
#    resources {
#      memory = 2
#      cores  = 2
#    }
#
#    boot_disk {
#      mode = "READ_WRITE"
#      initialize_params {
#        image_id = "fd89nebr9a651021u19i"
#        size     = 15
#      }
#    }
#
#    network_interface {
#      network_id = yandex_vpc_network.vpc_k8s_net.id
#      subnet_ids = ["${yandex_vpc_subnet.vpc_k8s_sub.id}"]
#      nat        = true
#
#    }
#
#    metadata = {
#      ssh-keys  = "localadm:${file("/home/localadm/.ssh/git.pub")}"
#      # user-data = "${file("/home/localadm/github/tulamelkii_repo/kubernetes-logging/local.txt")}"
#    }
#  }
#
#  scale_policy {
#    fixed_scale {
#      size = 2
#    }
#  }
#
#  allocation_policy {
#    zones = ["ru-central1-a"]
#  }
#
#  deploy_policy {
#    max_unavailable = 1
#    max_expansion   = 0
#  }
#}
#
##
