# Create group and add member.

# group for Software engineer
resource "azuread_group" "department" {
    display_name = "Devops Department"
    security_enabled = true
}

resource "azuread_group_member" "department" {
  for_each = { for user in azuread_user.users : user.first_name => user if user.department == "DevOps"}

  group_object_id = azuread_group.department.id
  member_object_id = each.value.id
}

# group for Manager
resource "azuread_group" "Software" {
  display_name = "Manager Department"
  security_enabled = true
}

resource "azuread_group_member" "Software" {
    for_each = { for user in azuread_user.users : user.first_name => user if user.job-title == "Software Engineer"}

    group_object_id = azuread_group.Software.id
    member_object_id = each.value.id
}
# group for Software engineer
resource "azuread_group" "Manager" {
    display_name = "Manager Department"
    security_enabled = true
}

resource "azuread_group_member" "Manager" {
  for_each = { for user in azuread_user.users : user.first_name => user if user.job-title == "Manager"}

  group_object_id = azuread_group.Manager.id
  member_object_id = each.value.id
}

