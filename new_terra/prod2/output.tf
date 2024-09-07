
output "date_create" {
  value = yandex_resourcemanager_folder.tera.created_at
}

output "folder_name" {
  value = yandex_resourcemanager_folder.tera.name
}

output "cloud_id" {
  value = yandex_resourcemanager_folder.tera.cloud_id
}
