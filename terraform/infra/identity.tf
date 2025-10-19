resource "azuread_application" "app" {
  provider     = azuread.cli_user
  display_name = "sp-${var.project_name}-databricks-${terraform.workspace}"
  owners       = [data.azuread_client_config.azuread_cli_user.object_id]
}

resource "azuread_service_principal" "sp" {
  provider                     = azuread.cli_user
  client_id                    = azuread_application.app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.azuread_cli_user.object_id]
}

resource "azurerm_role_assignment" "blob_contributor" {
  provider = azurerm.cli_user
  scope                 = azurerm_storage_account.adlsgen2.id
  role_definition_name  = "Storage Blob Data Contributor"
  principal_id          = azuread_service_principal.sp.object_id
}

resource "azuread_application_password" "app_password" {
  provider        = azuread.cli_user
  application_id  = azuread_application.app.id
}

resource "azurerm_key_vault_secret" "sp_secret" {
  name         = "secret-${azuread_application.app.display_name}"
  value        = azuread_application_password.app_password.value
  key_vault_id = azurerm_key_vault.kv.id
}