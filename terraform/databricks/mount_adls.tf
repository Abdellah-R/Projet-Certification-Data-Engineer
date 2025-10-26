data "databricks_current_user" "admin" {}

resource "databricks_notebook" "mount_adls" {
    path     = "/Users/${data.databricks_current_user.admin.user_name}/admin/notebooks/mount_adls"
    language = "PYTHON"

    content_base64 = base64encode(<<-EOT
        # Params
        service_credential = dbutils.secrets.get(scope="${databricks_secret_scope.scope.name}", key="secret-sp-${var.project_name}-databricks-${terraform.workspace}")
        application_id = "${var.application_id}"
        directory_id = "${var.tenant_id}"
        storage_account_name = "${data.azurerm_storage_account.adlsgen2.name}"
        container_name = "${data.azurerm_storage_container.container.name}"
        environment = "${terraform.workspace}"

        configs = {
        "fs.azure.account.auth.type": "OAuth",
        "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
        "fs.azure.account.oauth2.client.id": application_id,
        "fs.azure.account.oauth2.client.secret": service_credential,
        "fs.azure.account.oauth2.client.endpoint": f"https://login.microsoftonline.com/{directory_id}/oauth2/token"
        }
        
        # mount adls
        mount_point = f"/mnt/{environment}/{container_name}/"
        dbutils.fs.mount(
            source = f"abfss://{container_name}@{storage_account_name}.dfs.core.windows.net/",
            mount_point = mount_point,
            extra_configs = configs
        )
        EOT
    )
}