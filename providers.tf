# This file contains the provider configuration for 
#the Terraform script.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

# Configure the dtaabricks provider
provider "databricks" {
  host  = "https://<databricks-instance>.azuredatabricks.net"  # Replace with your Databricks workspace URL
  token = "your-databricks-token"  # Securely manage this token, e.g., via environment variables
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}