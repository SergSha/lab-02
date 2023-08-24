#output "external_ip_address_demo_vm" {
#  value = yandex_compute_instance.instances[*].network_interface[0].nat_ip_address
#}

output "vm_name" {
  value = var.vm_name
}

output "nat_ip_address" {
  value = var.nat_ip_address
}
