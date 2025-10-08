output "vm_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "vm_private_ip" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}