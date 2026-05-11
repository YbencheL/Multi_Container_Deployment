# Provider configuration details for Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.86.0"
    }
  }
}

# Provides configuration details for the Azure Terraform provider
provider "azurerm" {
  features {}
}

# Provides the Resource Group to Logically contain resources
resource "azurerm_resource_group" "rg" {
  name     = "Multi-container"
  location = var.location
  tags = {
    environment = "dev"
    source      = "Terraform"
    owner       = "yassine"
  }
}

# Manages a virtual network including any configured subnets
resource "azurerm_virtual_network" "vn" {
  name                = "Multi-container-network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
    source      = "Terraform"
    owner       = "yassine"
  }
}

/* Manages a subnet. Subnets represent network segments within 
the IP space defined by the virtual network.
*/
resource "azurerm_subnet" "subnet" {
  name                 = "Multi-container-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

# Manages a network security group that contains a list of network security rules.
resource "azurerm_network_security_group" "sg" {
  name                = "Multi-container-sg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "dev"
    source      = "Terraform"
    owner       = "yassine"
  }
}

# Manages a Network Security Rule.
resource "azurerm_network_security_rule" "rule" {
  name                        = "Multi-container-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.allowed_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sg.name
}

# Associates a Network Security Group with a Subnet within a Virtual Network.
resource "azurerm_subnet_network_security_group_association" "sga" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.sg.id
}

# Manages a Public IP Address.
resource "azurerm_public_ip" "ip" {
  name                = "Multi-container-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "dev"
    source      = "Terraform"
    owner       = "yassine"
  }
}

# Manages a Network Interface.
resource "azurerm_network_interface" "nic" {
  name                = "nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }

  tags = {
    environment = "dev"
    source      = "Terraform"
    owner       = "yassine"
  }
}

# Manages a Linux Virtual Machine.
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "Multy-continer-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}