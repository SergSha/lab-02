output "loadbalancers_info" {
  description = "General information about created VMs"
  value = [
    for vm in module.loadbalancers : {
      name = vm.vm_name
      nat_ip_address = vm.instance_external_ip_address
    }
  ]
}

output "backends_info" {
  description = "General information about created VMs"
  value = [
    for vm in module.backends : {
      name = vm.vm_name
      nat_ip_address = vm.instance_external_ip_address
    }
  ]
}
