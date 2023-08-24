output "nginx_vm_name" {
  value = module.nginxs[*].vm_name
}

output "backend_vm_name" {
  value = module.backends[*].vm_name
}

output "data_addr" {
  value = data.yandex_vpc_address.addr.external_ipv4_address
}