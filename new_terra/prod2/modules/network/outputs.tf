

output "network_id" {
  value = yandex_vpc_network.vpc_k8s_net.id
}

output "subnetwork_id" {
  value = yandex_vpc_subnet.vpc_k8s_sub.id
}
 

