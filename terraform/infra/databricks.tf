resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                = "databricks-workspace-${var.project_name}-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = local.databricks[terraform.workspace]["sku"]

  tags = {
    Environment = local.tags[terraform.workspace]
  }
}
