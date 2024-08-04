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
  type        = string
  default     = "ru-central1-a"
}
variable "bucket" {
  description =  "backet name"
  type        = string
}
variable "max_size" {
  description = "sive sorage"
  type        = number
}
variable "default_storage_class" {
  description  = "class storage"
  default     = "STANDARD"
}

