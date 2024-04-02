variable "subscription_id" {
  type        = string
  description = "Demo Subscription"
  default = "7ef199f3-53b2-4ae4-b178-56f7159813f8"
}

variable "role_description" {
  type        = string
  description = "This role will allow you to start and stop VM "
  default = "start-stop vm"
}

variable "role_name" {
  type        = string
  description = "Custom role"
  default = "start-stop"
}
