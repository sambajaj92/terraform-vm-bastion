output "vm_private_ip" {
  value = module.vm_bastion.vm_private_ip
}

output "bastion_connect_url" {
  value = module.vm_bastion.bastion_connect_url
}
