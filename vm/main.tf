
data "azurerm_log_analytics_workspace" "log_analytics_workspace_name" {
  count               = var.log_analytics_workspace_name != null ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group
}

module "rg" {
  source              = "./modules/rg"
  resource_group_name = try(coalesce(var.resource_group_name, "${local.prefix}-rg"), "canadacentral") #try(var.resource_group_name, "${local.prefix}-rg")
  location            = coalesce(var.location, "canadacentral")
  tags                = var.tags
  prefix              = local.prefix
}

module "network" {
  source                                     = "./modules/network"
  address_space                              = var.address_space
  tags                                       = merge(local.tags, var.tags)
  prefix                                     = local.prefix
  resource_group_name                        = coalesce(var.resource_group_name, "${local.prefix}-rg")
  location                                   = try(var.location, "canadacentral")
  log_analytics_workspace_id                 = data.azurerm_log_analytics_workspace.log_analytics_workspace_name[0].id
  subnets                                    = var.subnets
  security_groups                            = var.security_groups
  subnet_network_security_group_associations = var.subnet_network_security_group_associations
}

module "webvm" {
  for_each                   = { for vm in var.linux_vm : vm.name => vm }
  source                     = "./modules/vm"
  linux_vm                   = each.value
  tags                       = var.tags
  prefix                     = local.prefix
  resource_group_name        = module.rg.rg_name
  location                   = module.rg.rg_location
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace_name
  subnet_id                  = module.network.subnet_name_ids["app-subnet"]
}
