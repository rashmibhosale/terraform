variable "resource_group_name" {
  default     = "demo-rg-01"
  description = "This resource group is used to create resource for demo"
  type        = string
}

variable "location" {
  default = "South India"
  type    = string
}

variable "vnet_name" {
  type    = string
  default = "demo-vnet"
}

variable "subnet_name" {
  type    = string
  default = "demo-subnet"
}

variable "publicip_name" {
  type    = string
  default = "demo-public-ip-02"
}

variable "nsg_name" {
  type = string
  default = "demo-nsg-01"
}

variable "nic_name" {
  type = string
  default = "demo-nic"
}

variable "linux_vm" {
  type = string
  default = "demo-linux-vm"
}

variable "role_name" {
	type = string
	default = "CustomRole"
}

variable "AZURE_SUBSCRIPTION_ID" {
	type = string
	default = "7ef199f3-53b2-4ae4-b178-56f7159813f8"
}

variable "role_actions" {
	description = "List of actions allowed"
	type = list(string)
	default = [
		"Microsoft.Compute/virtualMachines/read",
		"Microsoft.Compute/virtualMachines/start/action",
    "Microsoft.Compute/virtualMachines/deallocate/action",
    "Microsoft.Storage/storageAccounts/listKeys/action"
	]
}
