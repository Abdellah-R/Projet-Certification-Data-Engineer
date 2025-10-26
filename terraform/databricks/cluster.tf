resource "databricks_cluster" "cluster" {
  cluster_name            = "${terraform.workspace}-cluster-admin"
  spark_version           = "13.3.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 60

  autoscale {
    min_workers = 1
    max_workers = 5
  }

  custom_tags = {
    Environment = local.tags[terraform.workspace]
  }
}
