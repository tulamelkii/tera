
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}


resource "yandex_compute_instance_group" "instgroup" {

  folder_id          = var.folder_id
  name               = var.group_name 
  service_account_id = var.service_account_id
  instance_template {
    resources {
      memory = var.resource_memory
      cores  = var.resource_cores 
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.image_id
        size     = var.size 
      }
    }

    network_interface {
      network_id = var.network_id
      subnet_ids = [var.subnet_ids]
      nat        = true

    }

    metadata = {
      ssh-keys = "${var.user_name_ssh}:${file(var.ssh_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.scale_size 
    }
  }

  allocation_policy {
    zones = [var.zones]
  }

  deploy_policy {
    max_unavailable = var.max_unavailable  
    max_expansion   = var.max_expansion
  }
}

