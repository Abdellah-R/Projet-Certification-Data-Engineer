resource "null_resource" "upload_files" {

    # triggers = {
    #   always_run = timestamp()  # Uncomment to force re-execution on each `terraform apply`
    # }

    provisioner "local-exec" {
        command = <<EOT
            ${path.module}/.venv/bin/python ${path.module}/scripts/upload_files_adls.py \
            ${azurerm_storage_account.adlsgen2.name} \
            ${azurerm_storage_account.adlsgen2.primary_access_key} \
            ${azurerm_storage_container.container.name}
        EOT
    }

    depends_on = [
        azurerm_storage_account.adlsgen2, 
        azurerm_storage_container.container
    ]
}