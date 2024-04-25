terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
   backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-centralindia"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "csg10032003748e0302"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "terraform"                       # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "tf"        # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true 
  client_id = var.clientid
  client_secret = var.clustersecrect
  subscription_id = var.subscriptionid
  tenant_id = var.tenantid
  features {

  }
}