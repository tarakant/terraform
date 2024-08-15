
resource "azurerm_virtual_network" "vnet" {

  name                = "${var.prefix}-vnet"
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  location            = var.location

  tags = merge(var.tags, {})
}

resource "azurerm_subnet" "subnet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]

  service_endpoints = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation != null ? each.value.delegation : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }

  lifecycle {
    ignore_changes = [
      address_prefixes,
      service_endpoints,
      delegation,
      tags
    ]
  }

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_network_security_group" "nsg" {
  for_each = { for sg in var.security_groups : sg.name => sg }

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = each.value.rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = merge(var.tags, {})

  depends_on = [azurerm_virtual_network.vnet]

  lifecycle {
    ignore_changes = [
      security_rule,
      tags
    ]
  }
}


resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each                  = { for subnet in var.subnet_network_security_group_associations : subnet.subnet_name => subnet }
  subnet_id                 = azurerm_subnet.subnet[each.value.subnet_name].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.network_security_group_name].id
}

resource "azurerm_monitor_diagnostic_setting" "settings" {
  name                       = "DiagnosticsSettings"
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
  }

}
