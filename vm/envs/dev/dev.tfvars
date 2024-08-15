#Params for the dev environment
env     = "dev"
dept    = "it"
project = "iam"

log_analytics_workspace_name           = "nonprod-law-canada-central"
log_analytics_workspace_resource_group = "observability-rg"

#Resource Group Details
#resource_group_name = "nonprod-rg"
location = "canadacentral"

#vnet details
address_space = ["10.0.0.0/16"]
# ddos_protection_plan = true
# encryption           = true
# enforcement          = "AllowUnencrypted"

subnets = [
  {
    name : "app-subnet",
    address_prefix : "10.0.1.0/24",
    #delegation        = null
    #service_endpoints = []
    delegation = [
      {
        name : "acctestdelegation",
        service_delegation : {
          name : "Microsoft.ContainerInstance/containerGroups",
          actions : ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    ]
    service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]
    nsg : ["nsg-app"]
  },
  {
    name : "web-subnet",
    address_prefix : "10.0.2.0/24",
    delegation        = null
    service_endpoints = []
    nsg : ["nsg-web"]
  }
]

security_groups = [
  {
    name : "nsg-app",
    rules : [
      {
        name : "nsg-app-rule-1",
        priority : 100,
        direction : "Inbound",
        access : "Allow",
        protocol : "Tcp",
        source_port_range : "*",
        destination_port_range : "80",
        source_address_prefix : "*",
        destination_address_prefix : "*",
      },
      {
        name : "rule-2",
        priority : 200,
        direction : "Inbound",
        access : "Allow",
        protocol : "Tcp",
        source_port_range : "*",
        destination_port_range : "443",
        source_address_prefix : "*",
        destination_address_prefix : "*",
      }
    ]
  },
  {
    name : "nsg-web",
    rules : [
      {
        name : "rule-1",
        priority : 100,
        direction : "Inbound",
        access : "Allow",
        protocol : "Tcp",
        source_port_range : "*",
        destination_port_range : "22",
        source_address_prefix : "*",
        destination_address_prefix : "*",
      }
    ]
  }
]

subnet_network_security_group_associations = [
  {
    subnet_name : "app-subnet",
    network_security_group_name : "nsg-app"
  },
  {
    subnet_name : "web-subnet",
    network_security_group_name : "nsg-web"
  }
]

linux_vm = [
  {
    count = 2,
    "name" : "web-vm",
    "size" : "Standard_B1s",
    "computer_name" : "linuxvm",
    "admin_username" : "adminuser",
    "admin_password" : "Password",
    "os_disk" : {
      "caching" : "ReadWrite",
      "storage_account_type" : "Standard_LRS",
      "disk_size_gb" : 30
    },
    "network_interface" : {
      "name" : "linux-nic",
      "private_ip_address_allocation" : "Dynamic",
      "subnet_name" : "web-subnet",
      "public_ip" : {
        "enable" : true,
        "name" : "linux-public-ip"
      }
    },
    "source_image_reference" : {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    },
    "custom_data" : "cloud-init.sh",

    admin_username = "adminuser",
    admin_password = "Password!1"
  },
  {
    count = 2,
    "name" : "app-vm",
    "size" : "Standard_B1s",
    "computer_name" : "linuxvm",
    "admin_username" : "adminuser",
    "admin_password" : "Password",
    "os_disk" : {
      "caching" : "ReadWrite",
      "storage_account_type" : "Standard_LRS",
      "disk_size_gb" : 30
    },
    "network_interface" : {
      "name" : "linux-nic",
      "private_ip_address_allocation" : "Dynamic",
      "subnet_name" : "app-subnet",
      "public_ip" : {
        "enable" : true,
        "name" : "linux-public-ip"
      }
    },
    "source_image_reference" : {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    },
    "custom_data" : "cloud-init.sh",

    admin_username = "adminuser",
    admin_password = "Password!1"
    #ublic_key     = file("${root.path}/scripts/ssh-key/id_rsa.pub")

  }
]
