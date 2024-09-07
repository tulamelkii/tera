

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = var.zones
}



#######################FOLDER+AIM_SERVICE_ACCOUNT#############

data "yandex_resourcemanager_folder" "tera" {
 name = var.folder_name
}


resource "yandex_resourcemanager_folder" "tera" {
  cloud_id    = var.cloud_id
  name        = var.folder_name
  description = "folder from otus terraform"
}

#################################################

module "new_service_account" {
   source          = "./modules/new_service_account"
   name_service_a  = var.name_service_a
   folder_id       = yandex_resourcemanager_folder.tera.id
   depends_on      = [yandex_resourcemanager_folder.tera]
}

resource "yandex_resourcemanager_folder_iam_member" "admin" {
   folder_id       = yandex_resourcemanager_folder.tera.id
   role            = var.role 
   member          = "serviceAccount:${module.new_service_account.service_account_id}"
   depends_on      = [module.new_service_account]
}




#######################create service-access and s3 storage #########################
#
#resource "yandex_iam_service_account_static_access_key" "access_key" {
#  service_account_id = yandex_iam_service_account.service-account.id
#
#}
#
#resource "yandex_storage_bucket" "test" {
#  access_key            = yandex_iam_service_account_static_access_key.access_key.access_key
#  secret_key            = yandex_iam_service_account_static_access_key.access_key.secret_key
#  bucket                = var.bucket
#  max_size              = var.max_size
#  default_storage_class = var.default_storage_class
#  folder_id             = yandex_resourcemanager_folder.tera.id
#
#  anonymous_access_flags {
#    read        = true
#    list        = true
#    config_read = true
#  }
#}
#
###########################CREATE_NETWORK############################################
module "networks" {
  source          = "./modules/network"
  folder_id       = yandex_resourcemanager_folder.tera.id
  name_vpc        = var.name_vpc
  v4_cidr_blocks  = var.v4_cidr_blocks 
  network_id      = "${module.networks.network_id}"
  zones           = var.zones
}
#
#####################################################################################
#  #resource "yandex_vpc_network" "vpc_k8s_net" {
#  #  folder_id   = yandex_resourcemanager_folder.tera.id
#  #  name        = var.name_vpc
#  #  description = "virtual network cluster k8s for ru-central1-a"
#  #}
#  #
#  #
#  #resource "yandex_vpc_subnet" "vpc_k8s_sub" {
#  #  folder_id      = yandex_resourcemanager_folder.tera.id
#  #  name           = var.name_vpc
#  #  description    = "virtual subnet cluster k8s for ru-central1-a"
#  #  v4_cidr_blocks = var.vpc_subnet
#  #  network_id     = yandex_vpc_network.vpc_k8s_net.id
#  #  zone           = var.zones
#  #
#  #}
#
#############################localinventory##########################################
##
##
##resource "local_file" "inventory" {
##  depends_on = [yandex_compute_instance_group.control, yandex_compute_instance_group.worker]
##  content = templatefile("${path.module}/templates/inventory.tpl",
##          {
##  control = yandex_compute_instance_group.control.instances[*].network_interface[0].nat_ip_address
##  worker = yandex_compute_instance_group.worker.instances[*].network_interface[0].nat_ip_address
##  ansible_user = var.ansible_user
##  ansible_private_key_file = var.ssh_path
##          }
##)
##filename = "${path.module}/ansible/inventory"
##  
##    provisioner "local-exec" {
##    working_dir = "${path.module}/ansible/"
##    command = "sleep 40 && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory main.yaml"
##  }
##}
##
##
##############sec_group#############################################################
#resource "yandex_vpc_security_group" "allow_ssh" {
#  name       = "allow-ssh"
#  network_id = yandex_vpc_network.vpc_k8s_net.id
#  folder_id  = yandex_resourcemanager_folder.tera.id
#
#  dynamic "ingress" {
#    for_each = ["80", "8080", "22"]
#    content {
#      protocol       = var.protocol_sec_group
#      description    = "Allow SSH from anywhere"
#      from_port      = ingress.value
#      to_port        = ingress.value
#      v4_cidr_blocks = var.cidr_block_all
#    }
#  }
#  dynamic "egress" {
#    for_each = ["80", "8080", "22", "53"]
#    content {
#      protocol       = var.protocol_sec_group
#      description    = "Allow all outbound traffic"
#      from_port      = egress.value
#      to_port        = egress.value
#      v4_cidr_blocks = var.cidr_block_all
#    }
#  }
#
#}
#
#
#############################################################################
data "yandex_compute_image" "debian_image" {
  family = var.famili_images_c
}
module "instance_group_c" {
  source             = "./modules/instance_group"
  group_name         = var.group_name_c
  resource_memory    = var.resource_memory_c
  resource_cores     = var.resource_cores_c
  size               = var.size_c
  user_name_ssh      = var.user_name_ssh
  ssh_path           = var.ssh_path
  scale_size         = var.scale_size_c
  zones              = var.zones
  max_unavailable    = var.max_unavailable_c
  max_expansion      = var.max_expansion_c
  folder_id          = yandex_resourcemanager_folder.tera.id
  service_account_id = "${module.new_service_account.service_account_id}"
  image_id           = data.yandex_compute_image.debian_image.id
  network_id         = "${module.networks.network_id}"
  subnet_ids         = "${module.networks.subnetwork_id}"
  depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
}
############################################################################
data "yandex_compute_image" "debian_image2" {
  family = var.famili_images_w
}

module "instance_group_w" {
  source             = "./modules/instance_group"
  group_name         = var.group_name_w
  resource_memory    = var.resource_memory_w
  resource_cores     = var.resource_cores_w
  size               = var.size_w
  user_name_ssh      = var.user_name_ssh
  ssh_path           = var.ssh_path
  scale_size         = var.scale_size_w
  zones              = var.zones
  max_unavailable    = var.max_unavailable_w
  max_expansion      = var.max_expansion_w
  folder_id          = yandex_resourcemanager_folder.tera.id
  service_account_id = "${module.new_service_account.service_account_id}"
  image_id           = data.yandex_compute_image.debian_image2.id
  network_id         = "${module.networks.network_id}"
  subnet_ids         = "${module.networks.subnetwork_id}"
  depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
}

############################################################################


data "yandex_compute_image" "debian_image3" {
  family = var.famili_images_h
}

module "instance_group_h" {
  source             = "./modules/instance_group"
  group_name         = var.group_name_h
  resource_memory    = var.resource_memory_h
  resource_cores     = var.resource_cores_h
  size               = var.size_h
  user_name_ssh      = var.user_name_ssh
  ssh_path           = var.ssh_path
  scale_size         = var.scale_size_h
  zones              = var.zones
  max_unavailable    = var.max_unavailable_h
  max_expansion      = var.max_expansion_h
  folder_id          = yandex_resourcemanager_folder.tera.id
  service_account_id = "${module.new_service_account.service_account_id}"
  image_id           = data.yandex_compute_image.debian_image2.id
  network_id         = "${module.networks.network_id}"
  subnet_ids         = "${module.networks.subnetwork_id}"
  depends_on         = [yandex_resourcemanager_folder_iam_member.admin]
}
