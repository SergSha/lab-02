
[all]
%{ for nginx in nginxs ~}
${ nginx["vm_name"] } ansible_host=${ nginx.network_interface.0.nat_ip_address }
%{ endfor ~}
%{ for backend in backends ~}
${ backend["vm_name"] }
%{ endfor ~}
