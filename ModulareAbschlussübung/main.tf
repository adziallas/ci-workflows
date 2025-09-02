provider "azurerm" {
  features {}
}

resource "azurerm_key_vault" "example" {
  name                = "kv-${var.username}-devops"
  location            = "West Europe"
  resource_group_name = "Kurs-2"
  tenant_id          = "<your-tenant-id>"
  soft_delete_retention_days = 7
}

resource "azurerm_key_vault_secret" "example" {
  name         = "apiToken"
  value        = "DummyValue"
  key_vault_id = azurerm_key_vault.example.id
}
