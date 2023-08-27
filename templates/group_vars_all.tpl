---
# group vars

#local_net: 192.168.1.0/24

#ip_address1:
#  fw: 192.168.1.11
#  web: 192.168.1.12
#  data: 192.168.1.13
#  replica: 192.168.1.14
#  backup: 192.168.1.15
#  logger: 192.168.1.16
#  monitor: 192.168.1.17

ip_address:
%{ for loadbalancer in loadbalancers ~}
  ${ loadbalancer["vm_name"] }: ${ loadbalancer["instance_internal_ip_address"] }
%{ endfor ~}
%{ for backend in backends ~}
  ${ backend["vm_name"] }: ${ backend["instance_internal_ip_address"] }
%{ endfor ~}