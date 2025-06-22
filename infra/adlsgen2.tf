resource "azurerm_storage_account" "adlsgen2" {
    name                     = "adls${var.project_name}${terraform.workspace}"
    resource_group_name      = var.resource_group_name
    location                 = var.resource_group_location
    account_replication_type = local.storage_account[terraform.workspace]["account_replication_type"]
    account_tier             = local.storage_account[terraform.workspace]["account_tier"]
    account_kind             = "StorageV2"
    access_tier              = "Hot"
    is_hns_enabled           = true

    tags = {
        Environment = local.tags[terraform.workspace]
    }
}

resource "azurerm_storage_container" "container" {
    name                     = "data"
    storage_account_name     = azurerm_storage_account.adlsgen2.name
    container_access_type    = "private"

    depends_on = [ 
        azurerm_storage_account.adlsgen2
    ]
}

resource "null_resource" "upload_data" {
    provisioner "local-exec" {
        command = <<EOT
            ${path.module}/.venv/bin/python ${path.module}/../data/upload_files_into_adls.py \
            ${azurerm_storage_account.adlsgen2.name} \
            ${azurerm_storage_account.adlsgen2.primary_access_key} \
            ${azurerm_storage_container.container.name}
        EOT
    }

    depends_on = [azurerm_storage_account.adlsgen2, azurerm_storage_container.container]
}

