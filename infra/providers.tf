terraform {
  required_version = ">=1.1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "your-resource-group-name"
    storage_account_name = "yourstorageaccount"
    container_name       = "yourcontainer"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

provider "azuread" {
  tenant_id     = var.tenant_id
  client_id     = var.client_id
  client_secret = var.client_secret
}
