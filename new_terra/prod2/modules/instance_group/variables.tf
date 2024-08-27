variable "folder_id" {
  description  = "folder_id"
  type         = string
}

variable "group_name_c" {
  description  = "group_name"
  type         =  string
}

variable "service_account_id" {
  description  = "id_service_account"
  type         = string
}

variable "resource_memory_c" {
  description  = "memory_size_control"
  type         =  number
}

variable "resource_cores_c" {
  description  = "cores_size_control"
  type         =  number
}

variable "image_id_c" {
  description  = "image_id_control"
  type         = string
}

variable "size_boot_disk_c" {
  description  = "disk_images_size_control"
  type         =  number
}

variable "network_id" {
  description = "network_id"
  type        = string
}

variable "subnet_id" {
  description = "subnet_id"
  type        = string
}

variable "user_name_ssh" {
  description = "name_user_ssh"
  type        = string
}

variable "ssh_path" {
  description = "path_to_ssh"
  type        =  string
}


variable "scale_size_c" {
  description  = "scale_images_control"
  type         =  number
}

variable "zone" {
  description = "zone"
  type        =  string
  default     = "ru-central1-a"
}

variable "max_unavailable_c" {
  description  = "max_unavailable_control"
  type         =  number
}

variable "max_expansion_c" {
  description  = "max_expansion_control"
  type         =  number
}

#######################################
variable "resource_memory_w" {
  description  = "memory_size_worker"
  type         =  number
}

variable "resource_cores_w" {
  description  = "cores_size_worker"
  type         =  number
}

variable "image_id_w" {
  description  = "image_id_worker"
  type         = string
}

variable "size_boot_disk_w" {
  description  = "disk_images_size_worker"
  type         =  number
}

variable "scale_size_w" {
  description  = "scale_images_worker"
  type         =  number
}

variable "max_unavailable_w" {
  description  = "max_unavailable_worker"
  type         =  number
}

variable "max_expansion_w" {
  description  = "max_expansion_worker"
  type         =  number
}

