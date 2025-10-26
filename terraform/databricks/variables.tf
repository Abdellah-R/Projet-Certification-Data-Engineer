############################
# Global
############################

variable "project_name" {
  description = "Project name, used as common keyword to naming the resources"
  type        = string
}


############################
# Authentication (Provider)
############################

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure Service Principal Client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure Service Principal Secret"
  type        = string
  sensitive   = true
}


############################
# Resource Group
############################

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "resource_group_location" {
  description = "Azure region for the Resource Group"
  type        = string
}


############################
# Databricks
############################

variable "databricks_host" {
  type        = string
  description = "URL of the Databricks workspace"
}

variable "databricks_resource_id" {
  type        = string
  description = "Resource ID of the Databricks workspace"
}

variable "application_id" {
  type        = string
  description = "Application (Client) ID of Service Principal for Databricks"
}