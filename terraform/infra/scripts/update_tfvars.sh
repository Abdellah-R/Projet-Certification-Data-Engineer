#!/bin/bash

# -----------------------------------------------------------------------------
# Script to update the databricks_host variable in terraform/env/<terraform workspace>/terraform.tfvars
#
# Notes:
# - This script is automatically called by Terraform in terraform/infra using a null_resource.
# - The target directory (terraform/env/<terraform workspace>/) must already exist.
# - This script adds or updates the databricks_host variable, along with a comment.
# -----------------------------------------------------------------------------

set -e

TF_WORKSPACE="$1"
DATABRICKS_HOST="$2"
DATABRICKS_RESOURCE_ID="$3"
APPLICATION_ID="$4"
TARGET_FILE="../../../terraform/env/${TF_WORKSPACE}/terraform.tfvars"
TARGET_DIR="$(dirname "$TARGET_FILE")"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: directory $TARGET_DIR does not exist. Please create it manually and add your variables before running this script."
  exit 1
fi

sed -i '/^# Databricks workspace host (auto-generated)/,+1d' "$TARGET_FILE"
sed -i '/^# Databricks resource id (auto-generated)/,+1d' "$TARGET_FILE"
sed -i '/^# Application (Client) ID of the Service Principal for Databricks (auto-generated)/,+1d' "$TARGET_FILE"

{
  echo ""
  echo "# Databricks workspace host (auto-generated)"
  echo "databricks_host = \"${DATABRICKS_HOST}\""
  echo ""
  echo "# Databricks resource id (auto-generated)"
  echo "databricks_resource_id = \"${DATABRICKS_RESOURCE_ID}\""
  echo ""
  echo "# Application (Client) ID of the Service Principal for Databricks (auto-generated)"
  echo "application_id = \"${APPLICATION_ID}\""
} >> "$TARGET_FILE"


echo "File updated : $TARGET_FILE"
