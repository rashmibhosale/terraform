# In this file we define custom roles to perform action on  virtual machine.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 1.0.0"
    }
  }
  # Defining the location remote satate file, so that multiple user can work together.
  backend "azurerm" {
    resource_group_name  = "backend-rg"
    storage_account_name = "terrastatebackend01"
    container_name       = "terrastatefile"
    key                  = "policy.terraform.tfstate"
  }
}
provider "azurerm" {
  features{}  
}

provider "azuread" {
  version = "~> 2.0"
}

data "azuread_group" "gp" {
  display_name = "demopolicygroup"
}

resource "azurerm_role_definition" "custom-vm-permission" {
  name = var.role_name
  scope = "/subscriptions/${var.subscription_id}"
  description = var.role_description

  permissions {
    actions = [ 
        "Microsoft.Compute/*/read",
        "Microsoft.Compute/virtualMachines/start/action",
        "Microsoft.Compute/virtualMachines/restart/action",
        "Microsoft.Compute/virtualMachines/deallocate/action"
     ]
     not_actions = [
     "Microsoft.Compute/virtualMachines/stop/action"
     ]
  }
  assignable_scopes = [ 
    "/subscriptions/${var.subscription_id}"
   ]
}

resource "azurerm_role_assignment" "assignrole-to-rg" {
  scope = "/subscriptions/${var.subscription_id}"
  role_definition_id = azurerm_role_definition.custom-vm-permission.id
  principal_id = data.azuread_group.gp.id
}
