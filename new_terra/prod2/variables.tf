

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

variable "name_vpc" {
  description = "name_vpc"
  type        = string
}

variable "vpc_subnet" {
  description = "cidr_vpc_subnet"
  type        = list(string)
}


variable "ansible_user" {
  description = "ansible_user_"
  type        = string
}


variable "sec_group_name" {
  description = "name_security_group"
  type        = string
}



variable "protocol_sec_group" {
  description = "protocol_network"
  type        = string
}


variable "cidr_block_all" {
  description = "cidr_block_allow_all"
  type        = list(string)
}

variable "user_name_ssh" {}

variable "ssh_path" {}

variable "zones" {}

variable "famili_images_c" {}

variable "group_name_c" {}

variable "resource_memory_c" {}

variable "resource_cores_c" {}

variable "scale_size_c" {}

variable "size_c" {}

variable "max_unavailable_c" {}

variable "max_expansion_c" {}

variable "famili_images_w" {}

variable "group_name_w" {}

variable "resource_memory_w" {}

variable "resource_cores_w" {}

variable "scale_size_w" {}

variable "size_w" {}

variable "max_unavailable_w" {}

variable "max_expansion_w" {}



