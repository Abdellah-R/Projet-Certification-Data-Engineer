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

resource "null_resource" "export_variables" {

#   triggers = {
#     always_run = timestamp()  # Uncomment to force re-execution on each `terraform apply`
#   }
    
  provisioner "local-exec" {
    command = <<EOT
      TF_WORKSPACE=${terraform.workspace}
      DATABRICKS_HOST=${azurerm_databricks_workspace.databricks_workspace.workspace_url}
      DATABRICKS_RESOURCE_ID=${azurerm_databricks_workspace.databricks_workspace.id}
      APPLICATION_ID=${azuread_application.app.client_id}
      cd ./scripts/
      bash update_tfvars.sh $TF_WORKSPACE $DATABRICKS_HOST $DATABRICKS_RESOURCE_ID $APPLICATION_ID
    EOT
  }

  depends_on = [
    azurerm_storage_account.adlsgen2,
    azurerm_storage_container.container,
    azuread_application.app
  ]
}