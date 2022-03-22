terraform{
   required_version = "1.1.0" 
}

provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.name_of_resource_group
  location = var.location
}

resource "azurerm_network_security_group" "example" {
  name                = var.nsg_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

data "azurerm_network_security_group" "example"{
    resource_group_name = azurerm_resource_group.example.name
    name = var.nsg_name   
}

output "tobi"{
  value = data.azurerm_network_security_group.example.name 
}


resource "azurerm_virtual_network" "example" {
  name                = "virtualNetwork1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = var.dns_server

  

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
    security_group = azurerm_network_security_group.example.id
  }

  tags = {
    environment = "Production"
  }
}


/* Below resource is a VPN gateway*/






resource "azurerm_subnet" "example" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "VPN_gateway_pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "example" {
  name                = "SOJ_VNG"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.example.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.example.id
  }
}





/*Below is a VNET/VPN gateway*/


resource "azurerm_virtual_network" "second" {
  name                = "virtualNetwork2"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["192.168.0.0/16"]
  dns_servers         = var.dns_server

 

  subnet {
    name           = "subnet1"
    address_prefix = "192.168.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "192.168.2.0/24"
  }

  subnet {
    name           = "subnet3"
    address_prefix = "192.168.3.0/24"
    security_group = azurerm_network_security_group.example.id
  }

  tags = {
    environment = "development"
  }
}



/* Below resource is second VPN gateway*/






resource "azurerm_subnet" "second" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.second.name
  address_prefixes     = ["192.168.4.0/24"]
}

resource "azurerm_public_ip" "second" {
  name                = "VPN_gateway_pip2"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "second" {
  name                = "SOJ_VNG2"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.second.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.second.id
  }
}
