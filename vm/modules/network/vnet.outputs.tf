
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_name_ids" {
  value = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}
