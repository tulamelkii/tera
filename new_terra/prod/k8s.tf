#############################YANDEX_PROVIDER#################
terraform {
  required_providers {
  yandex = {
    source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.76"
}


provider "yandex" {
  zone = var.zone 
}

#######################FOLDER+AIM_SERVICE_ACCOUNT#############

locals {
  folder_name  =  "terraform"
  sa_name      =  "service"
  role_sa      =  "admin"
  } 


resource "yandex_resourcemanager_folder" "tera" {
  cloud_id    =  var.cloud_id
  name        =  local.folder_name
  description = "folder from otus terraform"
}



resource "yandex_iam_service_account" "service-account" {
  name        =  local.sa_name
  folder_id   =  yandex_resourcemanager_folder.tera.id
  description = "service account from folder k8s-terra"
  depends_on  = [yandex_resourcemanager_folder.tera]
}
resource "yandex_resourcemanager_folder_iam_member" "admin" {
  folder_id  =  yandex_resourcemanager_folder.tera.id
  role       =  local.role_sa
  member     = "serviceAccount:${yandex_iam_service_account.service-account.id}"
  depends_on = [yandex_iam_service_account.service-account]
}

######################create service-access and s3 storage #########################

resource "yandex_iam_service_account_static_access_key" "access_key" {
service_account_id = yandex_iam_service_account.service-account.id

}

resource "yandex_storage_bucket" "test" {
  access_key            = yandex_iam_service_account_static_access_key.access_key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.access_key.secret_key
  bucket                = var.bucket
  max_size              = var.max_size
  default_storage_class = var.default_storage_class
  folder_id = yandex_resourcemanager_folder.tera.id
 
anonymous_access_flags {
  read        = true
  list        = true
  config_read = true
  }
}

##########################CREATE_NETWORK############################################


resource "yandex_vpc_network" "vpc_k8s_net" {
  folder_id   = yandex_resourcemanager_folder.tera.id
  name        = var.name_vpc
  description = "virtual network cluster k8s for ru-central1-a"
}


resource "yandex_vpc_subnet" "vpc_k8s_sub" {
  folder_id      = yandex_resourcemanager_folder.tera.id
  name           = var.name_vpc
  description    = "virtual subnet cluster k8s for ru-central1-a"
  v4_cidr_blocks = var.vpc_subnet
  network_id     = yandex_vpc_network.vpc_k8s_net.id
  zone           = var.zone
}

###########################localinventory##########################################


resource "local_file" "inventory" {
  depends_on = [yandex_compute_instance_group.control, yandex_compute_instance_group.worker]
  content = templatefile("${path.module}/templates/inventory.tpl",
          {
  control = yandex_compute_instance_group.control.instances[*].network_interface[0].nat_ip_address
  worker = yandex_compute_instance_group.worker.instances[*].network_interface[0].nat_ip_address
  ansible_user = var.ansible_user
  ansible_private_key_file = var.ssh_path
          }
)
filename = "${path.module}/ansible/inventory"
  
    provisioner "local-exec" {
    working_dir = "${path.module}/ansible/"
    command = "sleep 40 && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory main.yaml"
  }
}


#############sec_group#############################################################
resource "yandex_vpc_security_group" "allow_ssh" {
  name       = "allow-ssh"
  network_id = yandex_vpc_network.vpc_k8s_net.id
  folder_id  = yandex_resourcemanager_folder.tera.id

dynamic "ingress" {
   for_each = ["80","8080","22"]
   content {
    protocol       = var.protocol_sec_group
    description    = "Allow SSH from anywhere"
    from_port      = ingress.value
    to_port        = ingress.value
    v4_cidr_blocks = var.cidr_block_all
  }
}
dynamic "egress" {
  for_each = ["80","8080","22","53"]
  content {
    protocol       = var.protocol_sec_group
    description    = "Allow all outbound traffic"
    from_port      = egress.value
    to_port        = egress.value
    v4_cidr_blocks = var.cidr_block_all
  }
}

}
############# Instance group control#########################################

data "yandex_compute_image" "debian_image"{
     family = var.famili_images_c
   }


resource "yandex_compute_instance_group" "control" {
  folder_id          = yandex_resourcemanager_folder.tera.id
  name               = var.control_group_name
  service_account_id = yandex_iam_service_account.service-account.id
  depends_on         = [yandex_resourcemanager_folder_iam_member.admin
  ]

  instance_template {
    resources {
      memory = var.resource_memory_c
      cores  = var.resource_cores_c
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "${data.yandex_compute_image.debian_image.id}"
        size     = var.size_boot_disk
      }
    }

    network_interface {
      network_id = yandex_vpc_network.vpc_k8s_net.id
      subnet_ids = ["${yandex_vpc_subnet.vpc_k8s_sub.id}"]
      nat        = true
      
    }

    metadata = {
      ssh-keys     = "${var.user_name_ssh}:${file(var.ssh_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.scale_size_c
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = var.max_unavailable
    max_expansion   = var.max_expansion
  }
}
##################################################################################
data "yandex_compute_image" "debian_image_w"{
     family = var.famili_images_w
   }


resource "yandex_compute_instance_group" "worker" {
  folder_id          = yandex_resourcemanager_folder.tera.id
  name               = var.worker_group_name
  service_account_id = yandex_iam_service_account.service-account.id
  depends_on         = [yandex_resourcemanager_folder_iam_member.admin, yandex_compute_instance_group.control ]


  instance_template {
    resources {
      memory = var.resource_memory_w
      cores  = var.resource_cores_w
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "${data.yandex_compute_image.debian_image_w.id}"
        size     = var.size_boot_disk_w
      }
    }

    network_interface {
      network_id = yandex_vpc_network.vpc_k8s_net.id
      subnet_ids = ["${yandex_vpc_subnet.vpc_k8s_sub.id}"]
      nat        = true
      
    }

    metadata = {
      ssh-keys     = "${var.user_name_ssh}:${file(var.ssh_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.scale_size_w
    }
  }

  allocation_policy {
    zones = [var.zone]
  }

  deploy_policy {
    max_unavailable = var.max_unavailable_w
    max_expansion   = var.max_expansion_w
  }
}

