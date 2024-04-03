# Create user in Azure Active Directory and then create group in AD.
/*
Step 1. create user list.
Step 2. fetch domain of AD using data resource.
Step 3. Add user list & domains in Local as we calling this multiple times.
Step 4. create formated email id like user@domain.com
Step 5. Create formated password like , first letter of first_name then last name and then count of last_name and last exclamation sign(!)
        ex. scottm7!
*/

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.41.0"
    }
  }
  # Defining the location remote satate file, so that multiple user can work together.
  backend "azurerm" {
    resource_group_name  = "backend-rg"
    storage_account_name = "terrastatebackend01"
    container_name       = "terrastatefile"
    key                  = "ad.terraform.tfstate"
  }
}
provider "azuread" {
}

data "azuread_domains" "default" {
  only_initial = true
}

locals {
  domain_name = data.azuread_domains.default.domains.0.domain_name
  users       = csvdecode(file("${path.module}/userlist.csv"))
}
resource "random_pet" "suffix" {
  length = 2
}
resource "azuread_user" "users" {
  for_each = { for user in local.users : user.first_name => user }

  user_principal_name = format(
    "%s%s-%s@%s",
    substr(lower(each.value.first_name), 0 , 1),
    lower(each.value.last_name),
    random_pet.suffix.id,
    local.domain_name
  )

  password = format(
    "%s%s%s!",
    lower(each.value.last_name),
    substr(lower(each.value.first_name), 0 , 1),
    length(each.value.first_name)
  )
  force_password_change = true

  display_name = "${each.value.first_name} ${each.value.last_name}"
  department   = each.value.department
  job_title    = each.value.job_title
}
