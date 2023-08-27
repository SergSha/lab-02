
[all]
%{ for loadbalancer in loadbalancers ~}
${ loadbalancer["vm_name"] } ansible_host=${ loadbalancer["instance_external_ip_address"] }
%{ endfor ~}
%{ for backend in backends ~}
${ backend["vm_name"] } ansible_host=${ backend["instance_external_ip_address"] }
%{ endfor ~}

[loadbalancers]
%{ for loadbalancer in loadbalancers ~}
${ loadbalancer["vm_name"] }
%{ endfor ~}

[backends]
%{ for backend in backends ~}
${ backend["vm_name"] }
%{ endfor ~}