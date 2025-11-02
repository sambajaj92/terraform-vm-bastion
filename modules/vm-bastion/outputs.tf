output "vm_private_ip" {
  description = "Private IP address of the Windows VM"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "bastion_connect_url" {
  description = "Portal link to connect via Bastion"
  value       = "https://portal.azure.com/#resource${azurerm_bastion_host.bastion.id}/connect"
}
