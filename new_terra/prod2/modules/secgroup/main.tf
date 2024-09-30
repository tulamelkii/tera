terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}




resource "yandex_vpc_security_group" "allow_ssh" {
  name       = var.name_security_group
  network_id = var.network_id 
  folder_id  = var.folder_id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      protocol       = var.protocol
      description    = "Allow SSH from anywhere"
      from_port      = ingress.value
      to_port        = ingress.value
      v4_cidr_blocks = var.cidr_block_all
    }
  }
  dynamic "egress" {
    for_each = var.egress
    content {
      protocol       = var.protocol
      description    = "Allow all outbound traffic"
      from_port      = egress.value
      to_port        = egress.value
      v4_cidr_blocks = var.cidr_block_all
    }
  }

}

