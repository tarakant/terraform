
resource "azurerm_network_interface" "nic" {
  count               = var.linux_vm.count != null ? var.linux_vm.count : 1
  name                = "${var.linux_vm.name}-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.linux_vm.name}-ipconfig-${count.index}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.linux_vm.network_interface.private_ip_address_allocation
  }

  tags = merge(var.tags, { "location" : var.location })
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.linux_vm.count != null ? var.linux_vm.count : 1
  name                = "${var.linux_vm.name}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.linux_vm.size

  network_interface_ids = [azurerm_network_interface.nic["${count.index}"].id]

  os_disk {
    caching              = var.linux_vm.os_disk.caching
    storage_account_type = var.linux_vm.os_disk.storage_account_type
    disk_size_gb         = var.linux_vm.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = var.linux_vm.source_image_reference.publisher
    offer     = var.linux_vm.source_image_reference.offer
    sku       = var.linux_vm.source_image_reference.sku
    version   = var.linux_vm.source_image_reference.version
  }

  admin_username = var.linux_vm.admin_username
  admin_password = var.linux_vm.admin_password
  # admin_ssh_key {
  #   username   = var.linux_vm.admin_username
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }
}
