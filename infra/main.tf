data "azurerm_client_config" "current" {}

data "azuread_service_principal" "sp_terraform" {
  object_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}