# In this file we define custom roles to perform action on  virtual machine.

provider "azurerm" {
  features{}  
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
    "/subscription/${var.subscription_id}"
   ]
}

resource "azurerm_role_assignment" "assignrole-to-rg" {
  scope = "/subscription/${var.subscription_id}/resourceGroup/demorg"
  role_definition_id = azurerm_role_definition.custom-vm-permission.id
  principal_id = "f4a3a932-17f8-4970-b0e6-6bc5f427df7f"
}
