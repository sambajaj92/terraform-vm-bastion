variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "resource_group_name" {
  type        = string
  description = "Existing Resource Group"
}

variable "vnet_name" {
  type        = string
  description = "Existing VNet name"
}

variable "subnet_name" {
  type        = string
  description = "Existing Subnet name for the VM"
}

variable "nsg_name" {
  type        = string
  description = "Existing Network Security Group name"
}

variable "key_vault_name" {
  type        = string
  description = "Existing Azure Key Vault containing secrets"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "CIDR prefix for Bastion subnet"
}
