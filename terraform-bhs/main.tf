terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  # Defining the location remote satate file, so that multiple user can work together.
  backend "azurerm" {
    resource_group_name  = "backend-rg"
    storage_account_name = "terrastatebackend01"
    container_name       = "terrastatefile"
    key                  = "demo.terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pubip" {
  count               = 2
  name                = "${var.publicip_name}-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "${var.nic_name}-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNICConfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.pubip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "linvm" {
  count               = 2
  name                = "${var.linux_vm}-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  size                = "Standard_DS1_v2"

  admin_username = "rajeev"
  admin_ssh_key {
    username   = "rajeev"
    public_key = file("${path.module}/ssh-key/key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

# Create user
resource "azuread_user" "userA" {
  user_principal_name = "userA@brashmi97gmail.onmicrosoft.com" 
  display_name        = "userA"
  password            = "Azure@123"
}


# Define the custom RBAC role
resource "azurerm_role_definition" "custom_role" {
name               = "custom_role_creation"
scope              = "/subscriptions/7ef199f3-53b2-4ae4-b178-56f7159813f8"
 description        = "demo"
 permissions {
    actions = var.role_actions
   not_actions = []
 }
assignable_scopes = [
 "/subscriptions/7ef199f3-53b2-4ae4-b178-56f7159813f8"
 ]
}

# Assign the custom RBAC role to a user
resource "azurerm_role_assignment" "custom_role_assignment" {
scope              = "/subscriptions/7ef199f3-53b2-4ae4-b178-56f7159813f8"
role_definition_name = azurerm_role_definition.custom_role.name
#role_definition_id = azurerm_role_definition.custom_role.id
principal_id       = azuread_user.userA.object_id

depends_on = [
  azuread_user.userA,
  azurerm_resource_group.rg
]
}
