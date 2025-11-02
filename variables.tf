variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Existing Resource Group name"
  type        = string
}

variable "vnet_name" {
  description = "Existing Virtual Network name"
  type        = string
}

variable "subnet_name" {
  description = "Existing Subnet name for the VM"
  type        = string
}

variable "nsg_name" {
  description = "Existing NSG name"
  type        = string
}

variable "key_vault_name" {
  description = "Existing Azure Key Vault name containing secrets"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus2"
}

variable "bastion_subnet_prefix" {
  description = "Address prefix for Bastion subnet"
  type        = string
  default     = "10.0.3.0/27"
}
