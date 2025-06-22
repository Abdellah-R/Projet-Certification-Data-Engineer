### SP Terraform

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure application (Service Principal) ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Service Principal secret"
  type        = string
  sensitive   = true
}

### Resource Group

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
}

variable "resource_group_location" {
  type        = string
  description = "Azure region where the resource group is created"
}

### Common Keyword

variable "project_name" {
  description = "Project name, used as common keyword to naming the resources"
  type        = string
}


