terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0, < 5.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Data sources to fetch existing resources
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Public IPs for VMs
resource "azurerm_public_ip" "vm1_pip" {
  name                = "vm1-public-ip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "vm2_pip" {
  name                = "vm2-public-ip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

# Network Interfaces
resource "azurerm_network_interface" "nic1" {
  name                = var.vm1_nic_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1_pip.id
  }
}

resource "azurerm_network_interface" "nic2" {
  name                = var.vm2_nic_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm2_pip.id
  }
}

#  Attach NSG to NICs
resource "azurerm_network_interface_security_group_association" "vm_nsg_assoc1" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "vm_nsg_assoc2" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}

# Virtual Machine 1
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = var.vm1_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic1.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 130
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"  # Fixed
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(file("vm_configuration.sh"))
}

# Virtual Machine 2
resource "azurerm_linux_virtual_machine" "vm2" {
  name                = var.vm2_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic2.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 130
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"  # Fixed
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(file("vm_configuration.sh"))
}


# Create a 500GB Managed Disk
resource "azurerm_managed_disk" "vm1_data_disk" {
  name                 = "vm1-data-disk"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_type = "Premium_LRS"
  disk_size_gb         = 500
  create_option        = "Empty"
}

# Attach the Managed Disk to VM1
resource "azurerm_virtual_machine_data_disk_attachment" "vm1_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.vm1_data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm1.id
  lun               = 0  # Logical Unit Number (LUN)
  caching           = "ReadWrite"
}