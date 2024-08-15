

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = merge(var.tags, { "location" : var.location })

  lifecycle {
    ignore_changes = [tags]
  }
}
