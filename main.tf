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

data "yandex_vpc_address" "addr" {
  address_id = yandex_vpc_network.vpc.id
}

module "nginxs" {
  source = "./modules/instances"

  count = 1

  vm_name = "nginx-${count.index + 1}"
  vpc_name = local.vpc_name
  subnet_cidrs = yandex_vpc_subnet.subnet.v4_cidr_blocks
  subnet_name = yandex_vpc_subnet.subnet.name
  subnet_id = yandex_vpc_subnet.subnet.id
  vm_user = local.vm_user
  ssh_public_key = local.ssh_public_key

}

module "backends" {
  source = "./modules/instances"

  count = 2

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
      nginxs = module.nginxs
      backends   = module.backends
    }
  )
  filename = "./inventory.ini"
}
