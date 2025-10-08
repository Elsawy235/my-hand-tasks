output "vm1_public_ip" {
  description = "The public IP address of VM1"
  value       = azurerm_public_ip.vm1_pip.ip_address
}

output "vm2_public_ip" {
  description = "The public IP address of VM2"
  value       = azurerm_public_ip.vm2_pip.ip_address
}
output "vm1_private_ip" {
  description = "Private IP of VM1"
  value       = azurerm_network_interface.nic1.private_ip_address
}



output "vm2_private_ip" {
  description = "Private IP of VM2"
  value       = azurerm_network_interface.nic2.private_ip_address
}


