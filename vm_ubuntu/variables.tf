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

variable "vm1_name" {
  description = "Name of the first virtual machine"
  type        = string
}

variable "vm2_name" {
  description = "Name of the second virtual machine"
  type        = string
}

variable "vm1_nic_name" {
  description = "Name of the network interface for VM1"
  type        = string
}

variable "vm2_nic_name" {
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

variable "disk_size_gb" {
  description = "Size of the additional managed disk for VM1"
  type        = number
  default     = 500
}

variable "vm_size" {                                      # 4 vCPUs,8GB RAM and Supports SSD & Premium Disks
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_D4s_v3"
}