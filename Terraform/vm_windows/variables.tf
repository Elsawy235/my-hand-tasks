variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}


variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}


variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
}

variable "vm3_name" {
  description = "Name of the first virtual machine"
  type        = string
}

variable "vm3_nic_name" {
  description = "Name of the network interface for VM2"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machines"
  type        = string
  sensitive   = true
}

variable "vm_size" {                                      # 4 vCPUs,8GB RAM and Supports SSD & Premium Disks
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_D2s_v3"
}