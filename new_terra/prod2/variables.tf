variable "cloud_id" {
  description = "cloud_id"
  type        = string
}


variable "folder_name" {
}

variable "name_service_a" {
 description = "Service account name"
  type        = string
}

variable "role" {
  description = "role_service_account"
  type        = string
}
#############S3#####################################
variable "bucket" {
  description = "bucket"
  type        = string
}

variable "max_size" {
  description = "max_size_bucket"
  type        = string
}

variable "default_storage_class" {
  description = "class storage"
  default     = "STANDARD"
}

#variable "access_key" {}

#variable "secret_key" {}

#####################Module_network##################
variable "name_vpc" {
  #  description = "name_vpc"
  # type        = string
}
variable "v4_cidr_blocks" { }

########################################

variable "ansible_user" {
  description = "ansible_user_"
  type        = string
}
######################################
variable "name_security_group" {
  description = "name_security_group"
  type        = string
}

variable "protocol" {
  description = "protocol"
  type        = string
}

variable "cidr_block_all" {
  description = "cidr_block_allow_all"
  type        = list(string)
}
variable "ingress" {
 description = "A list of ports to allow incoming traffic on"
  type        = list(number)
}

variable "egress" {
  description = "A list of ports to allow outgoing traffic on"
  type        = list(number)
}
#######################################
variable "user_name_ssh" {}

variable "ssh_path" {}

variable "zones" {}
##########WAR_CONTROL#############
variable "famili_images_c" {}

variable "group_name_c" {}

variable "resource_memory_c" {}

variable "resource_cores_c" {}

variable "scale_size_c" {}

variable "size_c" {}

variable "max_unavailable_c" {}

variable "max_expansion_c" {}
##########WAR_WORKER##############
variable "famili_images_w" {}

variable "group_name_w" {}

variable "resource_memory_w" {}

variable "resource_cores_w" {}

variable "scale_size_w" {}

variable "size_w" {}

variable "max_unavailable_w" {}

variable "max_expansion_w" {}

#########WAR_HAPROXY#############

variable "famili_images_h" {}

variable "group_name_h" {}

variable "resource_memory_h" {}

variable "resource_cores_h" {}

variable "scale_size_h" {}

variable "size_h" {}

variable "max_unavailable_h" {}

variable "max_expansion_h" {}




