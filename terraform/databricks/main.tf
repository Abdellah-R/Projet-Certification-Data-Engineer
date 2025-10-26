data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_storage_account" "adlsgen2" {
  name = "adls${var.project_name}${terraform.workspace}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_storage_container" "container" {
  name = "data"
  storage_account_id = data.azurerm_storage_account.adlsgen2.id
}

data "azurerm_key_vault" "kv" {
  name                = "kv-${var.project_name}-${terraform.workspace}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_databricks_workspace" "databricks_workspace" {
  name                = "databricks-workspace-${var.project_name}-${terraform.workspace}"
  resource_group_name = data.azurerm_resource_group.rg.name
}