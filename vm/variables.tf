variable "env" {
  description = "The environment to deploy the resources"
  type        = string
  validation {
    condition     = length(var.env) > 0
    error_message = "The environment must be a valid string"
  }
}

variable "dept" {
  description = "The department to deploy the resources"
  type        = string
  validation {
    condition     = length(var.dept) > 0
    error_message = "The department must be a valid string"
  }
}

variable "project" {
  description = "The project to deploy the resources"
  type        = string
  validation {
    condition     = length(var.project) > 0
    error_message = "The project must be a valid string"
  }
}

variable "tags" {
  description = "The tags for the resources"
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_name" {
  description = "Log analytics workspace name"
  type        = string
}

variable "log_analytics_workspace_resource_group" {
  description = "Log analytics workspace resource group"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  nullable    = true
  default     = null
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "canadacentral"
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = null
  nullable    = true
}

variable "subnets" {
  description = "The subnets for the virtual network"
  type = list(object({
    name           = string
    address_prefix = string
    #delegation        = optional(string)
    delegation = optional(list(
      object({
        name = string
        service_delegation = object({
          name    = string
          actions = list(string)
        })
        }
    )))
    service_endpoints = optional(list(string))
    nsg               = list(string)
  }))
  default = null
}

variable "security_groups" {
  description = "The security groups for the virtual network"
  type = list(object({
    name = string
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
  default = null

}

variable "subnet_network_security_group_associations" {
  description = "The subnet network security group associations for the virtual network"
  type = list(object({
    subnet_name                 = string
    network_security_group_name = string
  }))
  default = null
}

variable "linux_vm" {
  description = "config for the linux virtual machine"
  type = list(object({
    count          = optional(number),
    name           = string,
    size           = string,
    computer_name  = string,
    admin_username = string,
    admin_password = string,
    custom_data    = optional(string)
    os_disk = optional(object({
      caching              = string,
      storage_account_type = string,
      disk_size_gb         = number
    }))

    network_interface = optional(object({
      name                          = string,
      private_ip_address_allocation = string,
      subnet_name                   = string,
      public_ip = optional(object({
        enable = bool,
        name   = string
      })),
    }))
    source_image_reference = object({
      publisher = string,
      offer     = string,
      sku       = string,
      version   = string
    })
  }))
  default = null
}

# variable "bgp_community" {
#   description = "The BGP community for the virtual network"
#   type        = optional(string)
# }

# variable "rg_data" {
#   description = "The data for the resource group"
#   type        = map(any)
#   default     = {}
# }

# variable "log_analytics_workspace_name" {
#   description = "Log analytics workspace name"
#   type        = string
# }

# variable "log_analytics_workspace_resource_group" {
#   description = "Log analytics workspace resource group"
#   type        = string
# }




