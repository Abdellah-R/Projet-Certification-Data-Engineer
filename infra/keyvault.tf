resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.project_name}-${terraform.workspace}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  key_vault_id            = azurerm_key_vault.kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id

  key_permissions         = [ "Get" ]
  secret_permissions      = ["Get", "List", "Set"]
  certificate_permissions = [ "Get" ]
}