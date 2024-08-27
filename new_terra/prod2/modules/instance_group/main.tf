
resource "yandex_compute_instance_group" "instgroup" {
  folder_id          = yandex_resourcemanager_folder.tera.id
  name               = var.group_name_c
  service_account_id = yandex_iam_service_account.service-account.id

  instance_template {
    resources {
      memory = var.resource_memory_c
      cores  = var.resource_cores_c
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.debian_image.id
        size_c     = var.size_c 
      }
    }

    network_interface {
      network_id = yandex_vpc_network.vpc_k8s_net.id 
      subnet_ids = yandex_vpc_subnet.vpc_k8s_sub.id 
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
    max_unavailable = var.max_unavailable_c
    max_expansion   = var.max_expansion_c
  }
}

