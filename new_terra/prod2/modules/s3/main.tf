terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}



resource "yandex_storage_bucket" "test" {
  access_key            = var.access_key
  secret_key            = var.secret_key
  bucket                = var.bucket
  max_size              = var.max_size
  default_storage_class = var.default_storage_class
  folder_id             = var.folder_id
  force_destroy         = true

  anonymous_access_flags {
    read        = true
    list        = true
    config_read = true
  }
}


