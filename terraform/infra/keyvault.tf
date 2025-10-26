resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.project_name}-${terraform.workspace}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = "standard"
  
  # SP Terraform
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover"
    ]

    storage_permissions = [
      "Get",
    ]
  }
  
  # Admin
  access_policy {
    tenant_id = data.azurerm_client_config.azurerm_cli_user.tenant_id
    object_id = data.azurerm_client_config.azurerm_cli_user.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}