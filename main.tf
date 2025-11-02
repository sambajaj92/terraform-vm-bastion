module "vm_bastion" {
  source = "./modules/vm-bastion"

  subscription_id      = var.subscription_id
  resource_group_name  = var.resource_group_name
  vnet_name            = var.vnet_name
  subnet_name          = var.subnet_name
  nsg_name             = var.nsg_name
  key_vault_name       = var.key_vault_name
  location             = var.location
  bastion_subnet_prefix = var.bastion_subnet_prefix
}
