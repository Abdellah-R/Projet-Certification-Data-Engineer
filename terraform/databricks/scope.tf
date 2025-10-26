resource "databricks_secret_scope" "scope" {
  name = "databricks-scope"
  initial_manage_principal = "users"

  keyvault_metadata {
    resource_id = data.azurerm_key_vault.kv.id
    dns_name    = data.azurerm_key_vault.kv.vault_uri
  }

  depends_on = [ data.azurerm_databricks_workspace.databricks_workspace ]
}