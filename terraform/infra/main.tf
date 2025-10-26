data "azurerm_client_config" "current" {}

data "azurerm_client_config" "azurerm_cli_user" {
  provider = azurerm.cli_user
}

data "azuread_client_config" "azuread_cli_user" {
  provider = azuread.cli_user
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}