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
  default = "demo-vnet-01"
}

variable "subnet_name" {
  type    = string
  default = "demo-subnet-01"
}

variable "publicip_name" {
  type    = string
  default = "demo-public-ip"
}

variable "nsg_name" {
  type = string
  default = "demo-nsg-01"
}

variable "nic_name" {
  type = string
  default = "demo-nic-01"
}

variable "linux_vm" {
  type = string
  default = "demo-linux-vm-01"
}
