variable "cloud_id" {
  description = "cloud"
  type        = string
}
variable "folder_id" {
  description = "folder id"
  type        = string
  default     = "b1g31j1d1i9gj2fbai51"
}
variable "zone" {
  description = "zone"
  type        =  string
  default     = "ru-central1-a"
}
#########S3_bucket##################

variable "bucket" {
  description =  "backet name"
  type        = string
}
variable "max_size" {
  description = "sive sorage"
  type        = number
}
variable "default_storage_class" {
  description = "class storage"
  default     = "STANDARD"
}
############vpc######################
variable "name_vpc" {
  description = "name_vpc"
  type        = string
}

variable "vpc_subnet" {
  description = "cidr_vpc_subnet"
  type        = list(string)
}
variable "cidr_block_all" {
  description = "cidr_block_allow_all"
  type        = list(string)
}
#####################################
variable "ansible_user" {
  description = "ansible_user_"
  type        = string
}  

variable "ssh_path" {
  description = "path_to_ssh"
  type        =  string
}
variable "user_name_ssh" {
  description = "name_user_ssh"
  type        = string
}

##########sec_group#################

variable "sec_group_name" {
  description = "name_security_group"
  type        =  string
}

variable "protocol_sec_group" {
  description = "protocol_network"
  type        =  string
}

###########first_group#############

variable "control_group_name" {
  description  = "name_control_group"
  type         =  string
}

variable "resource_memory_c" {
  description  = "memory_size"
  type         =  number
}

variable "resource_cores_c" {
  description  = "cores_size"
  type         =  number
}

variable "famili_images_c" {
  description  = "images"
  type         = string
}

variable "size_boot_disk" {
  description  = "disk_images_size"
  type         =  number
}

variable "scale_size_c" {
  description  = "scale_images"
  type         =  number
}

variable "max_unavailable" {
  description  = "max_unavailable"
  type         =  number
}


variable "max_expansion" {
  description  = "max_expansion"
  type         =  number
}

###########second_group################

variable "worker_group_name" {
  description  = "name_control_group"
  type         =  string
}

variable "resource_memory_w" {
  description  = "memory_size"
  type         =  number
}

variable "resource_cores_w" {
  description  = "cores_size"
  type         =  number
}

variable "famili_images_w" {
  description  = "images"
  type         = string
}

variable "size_boot_disk_w" {
  description  = "disk_images_size"
  type         =  number
}

variable "scale_size_w" {
  description  = "scale_images"
  type         =  number
}

variable "max_unavailable_w" {
  description  = "max_unavailable"
  type         =  number
}


variable "max_expansion_w" {
  description  = "max_expansion"
  type         =  number
}


