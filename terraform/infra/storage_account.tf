resource "azurerm_storage_account" "adlsgen2" {
    name                     = "adls${var.project_name}${terraform.workspace}"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_replication_type = local.storage_account[terraform.workspace]["account_replication_type"]
    account_tier             = local.storage_account[terraform.workspace]["account_tier"]
    account_kind             = "StorageV2"
    access_tier              = "Hot"
    is_hns_enabled           = "true"

    tags = {
        Environment = local.tags[terraform.workspace]
    }
}

resource "azurerm_storage_container" "container" {
    name                     = "data"
    storage_account_name     =  azurerm_storage_account.adlsgen2.name
    container_access_type    = "private"

    depends_on = [ 
        azurerm_storage_account.adlsgen2
    ]
 }
