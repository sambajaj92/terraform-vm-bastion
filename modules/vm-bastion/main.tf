# ──────────────────────────────────────────────
# Existing Resources
# ──────────────────────────────────────────────
data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing.name
}

data "azurerm_subnet" "existing_subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing.name
}

data "azurerm_network_security_group" "existing_nsg" {
  name                = var.nsg_name
  resource_group_name = data.azurerm_resource_group.existing.name
}

data "azurerm_key_vault" "existing_kv" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.existing.name
}

# ──────────────────────────────────────────────
# Secrets
# ──────────────────────────────────────────────
data "azurerm_key_vault_secret" "vm_username" {
  name         = "vm-admin-username"
  key_vault_id = data.azurerm_key_vault.existing_kv.id
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.existing_kv.id
}

# ──────────────────────────────────────────────
# NSG Rules for Bastion
# ──────────────────────────────────────────────
resource "azurerm_network_security_rule" "allow_rdp_from_bastion" {
  name                       = "Allow-RDP-From-Bastion"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "3389"
  source_address_prefix      = var.bastion_subnet_prefix
  destination_address_prefix = "*"
  resource_group_name         = data.azurerm_resource_group.existing.name
  network_security_group_name = data.azurerm_network_security_group.existing_nsg.name
}

# ──────────────────────────────────────────────
# Bastion Host
# ──────────────────────────────────────────────
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  address_prefixes     = [var.bastion_subnet_prefix]
}

resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "demo-bastion"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

# ──────────────────────────────────────────────
# VM + NIC
# ──────────────────────────────────────────────
resource "azurerm_network_interface" "vm_nic" {
  name                = "demo-vm-nic"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "demo-win-vm"
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  size                = "Standard_B1ms"
  admin_username      = data.azurerm_key_vault_secret.vm_username.value
  admin_password      = data.azurerm_key_vault_secret.vm_password.value
  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  os_disk {
    name                 = "demo-winvm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  computer_name = "demowinvm"
}
