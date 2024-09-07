
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}


resource "yandex_iam_service_account" "service-account" {
  name        = var.name_service_a
  folder_id   = var.folder_id
  description = "service account from folder k8s-terra"

}
