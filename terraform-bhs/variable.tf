variable "resource_group_name" {
  default     = "demo-rg-01"
  description = "This resource group is used to create resource for demo"
  type        = string
}
variable "item_count" {
  description = "Number of instance to create"
  type        = number
  default     = 3
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

variable "admin_password" {
  type = string
  default = "Password@123"
}
