locals {
  vm_user         = "debian"
  ssh_public_key  = "~/.ssh/otus.pub"
  ssh_private_key = "~/.ssh/otus"

  #vm_name = "instance"
  vpc_name = "my_vpc_network"
  subnet_cidrs = ["10.10.20.0/24"]
  subnet_name = "my_vpc_subnet"
}

resource "yandex_vpc_network" "vpc" {
  # folder_id = var.folder_id
  name = local.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  # folder_id = var.folder_id
  v4_cidr_blocks = local.subnet_cidrs
  zone           = local.zone
  name           = local.subnet_name
  network_id     = yandex_vpc_network.vpc.id
}

module "loadbalancers" {
  source = "./modules/instances"

  count = 1

  vm_name = "loadbalancer-${count.index + 1}"
  vpc_name = local.vpc_name
  subnet_cidrs = yandex_vpc_subnet.subnet.v4_cidr_blocks
  subnet_name = yandex_vpc_subnet.subnet.name
  subnet_id = yandex_vpc_subnet.subnet.id
  vm_user = local.vm_user
  ssh_public_key = local.ssh_public_key
}

module "backends" {
  source = "./modules/instances"

  count = 3

  vm_name = "backend-${count.index + 1}"
  vpc_name = local.vpc_name
  subnet_cidrs = yandex_vpc_subnet.subnet.v4_cidr_blocks
  subnet_name = yandex_vpc_subnet.subnet.name
  subnet_id = yandex_vpc_subnet.subnet.id
  vm_user = local.vm_user
  ssh_public_key = local.ssh_public_key
}

resource "local_file" "inventory_file" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      loadbalancers = module.loadbalancers
      backends      = module.backends
    }
  )
  filename = "${path.module}/inventory.ini"
}

resource "local_file" "group_vars_all_file" {
  content = templatefile("${path.module}/templates/group_vars_all.tpl",
    {
      loadbalancers = module.loadbalancers
      backends      = module.backends
    }
  )
  filename = "${path.module}/group_vars/all/main.yml"
}
/*
resource "null_resource" "loadbalancers" {

  count = length(module.loadbalancers)

  # Changes to the instance will cause the null_resource to be re-executed
  triggers = {
    name = "${module.loadbalancers[count.index].vm_name}"
  }

  # Running the remote provisioner like this ensures that ssh is up and running
  # before running the local provisioner

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
  }

  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = file(local.ssh_private_key)
    host        = "${module.loadbalancers[count.index].instance_external_ip_address}"
  }

  # Note that the -i flag expects a comma separated list, so the trailing comma is essential!

  provisioner "local-exec" {
    command = "ansible-playbook -u '${local.vm_user}' --private-key '${local.ssh_private_key}' --become -i ./inventory.ini -l '${module.loadbalancers[count.index].instance_external_ip_address},' provision.yml"
    #command = "ansible-playbook provision.yml -u '${local.vm_user}' --private-key '${local.ssh_private_key}' --become -i '${element(module.loadbalancers.nat_ip_address, 0)},' "
  }
}
*/
/*
resource "null_resource" "backends" {

  count = length(module.backends)

  # Changes to the instance will cause the null_resource to be re-executed
  triggers = {
    name = "${module.backends[count.index].vm_name}"
  }

  # Running the remote provisioner like this ensures that ssh is up and running
  # before running the local provisioner

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
  }

  connection {
    type        = "ssh"
    user        = local.vm_user
    private_key = file(local.ssh_private_key)
    host        = "${module.backends[count.index].instance_external_ip_address}"
  }

  # Note that the -i flag expects a comma separated list, so the trailing comma is essential!

  provisioner "local-exec" {
    command = "ansible-playbook -u '${local.vm_user}' --private-key '${local.ssh_private_key}' --become -i '${module.backends[count.index].instance_external_ip_address},' provision.yml"
    #command = "ansible-playbook provision.yml -u '${local.vm_user}' --private-key '${local.ssh_private_key}' --become -i '${element(module.loadbalancers.nat_ip_address, 0)},' "
  }
}
*/