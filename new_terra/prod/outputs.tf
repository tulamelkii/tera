#ioutput "cloud_id_01" {
#  value = yandex_resourcemanager_folder.tera.cloud_id
#}
#
#output "folder_id_02" {
#  value = yandex_resourcemanager_folder.tera.id
#}
#
#output "service_account_id" {
#  value = yandex_iam_service_account.service-account.id
#}
#
#output "sa_access_key_id" {
#  value = yandex_iam_service_account_static_access_key.access_key.access_key
#}
#
#output "bucket_domain_name" {
#  value = yandex_storage_bucket.test.bucket_domain_name
#}
#
#output "s3_bucket_id" {
#  value = yandex_storage_bucket.test.id
#}
#
#output "security_group_id" {
#  value = yandex_vpc_security_group.allow_ssh.id
#}
#
#output "vpc_subnet_id" {
#  value = yandex_vpc_subnet.vpc_k8s_sub.id
#}
#
#output "control_group_instance_id" {
#  value = yandex_compute_instance_group.control.id
#}
#
##output "vpc_network_id" {
##  value = yandex_vpc_network.vpc_k8s_net.id
##}
##
##output "control_plane" {
##  value = [ for instance in yandex_compute_instance_group.control.instances : instance.network_interface[0].ip_address ]
##}
##
##
##output "ip_worker_nodes" {
##  value = [ for instance in yandex_compute_instance_group.worker.instances : instance.network_interface[0].ip_address ]
##}
#
#output "netwo_info" {
#  value = {
#     vpc_network_id = yandex_vpc_network.vpc_k8s_net.id
#     control_plane  = [ for instance in yandex_compute_instance_group.control.instances : instance.network_interface[0].ip_address ]  
#     ip_worker_nodes = [ for instance in yandex_compute_instance_group.worker.instances : instance.network_interface[0].ip_address] 
#}
#}
#
