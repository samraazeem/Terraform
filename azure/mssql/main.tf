# data "azuread_group" "ad" {
#   display_name = var.azuread_administrator_object #"TTX-POC-Azure-Synapse-Spark-Admin-Dev"
# }

resource "azurerm_mssql_server" "mssql" {
  name                         = var.name
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = var.mssql_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = var.minimum_tls_version
  connection_policy = var.connection_policy
  tags = var.tags
  public_network_access_enabled = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled


  azuread_administrator {
    login_username = var.azuread_administrator_name
    object_id = var.azuread_administrator_object
  }
  
  dynamic "identity" {
    for_each = var.identity == null ? [] : [true]
    content {
      type         = lookup(var.identity, "type", null)
      identity_ids = lookup(var.identity, "identity_ids", null)
    }
  }

  # variable "identity" {
  #   type = any
  #   description = <<EOT
  #       type = Specifies the type of Managed Service Identity that should be configured on the Cognitive Account. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).
  #       identity_ids = A list of IDs for User Assigned Managed Identity resources to be assigned.
  #   EOT
  #   default = null
  # }

}

resource "azurerm_mssql_firewall_rule" "firewalls" {
  for_each = var.public_network_access_enabled ==  true ? {for firewall in var.firewall_rules : firewall.name => firewall } : {}
  name                = each.value.name
  server_id        = azurerm_mssql_server.mssql.id
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
  depends_on = [
    azurerm_mssql_server.mssql
  ]
}

resource "azurerm_mssql_virtual_network_rule" "netrules" {
  for_each = var.public_network_access_enabled ==  true ? {for sub in var.net_subnets : sub.name => sub } : {}
  name      = each.value.name
  server_id = azurerm_mssql_server.mssql.id
  subnet_id = each.value.subnet_id
}

resource "azurerm_mssql_server_extended_auditing_policy" "auditpolicy" {
  count = var.enable_auditing == true ? 1 : 0
  server_id                               = azurerm_mssql_server.mssql.id
  storage_endpoint                        = lookup(var.auditing_settings, "primary_blob_endpoint", null)
  storage_account_access_key              = lookup(var.auditing_settings, "blob_access_key", null)
  storage_account_access_key_is_secondary = lookup(var.auditing_settings, "is_secondary_key", false)
  retention_in_days                       = lookup(var.auditing_settings, "retention_in_days", 7)
  depends_on = [
    azurerm_role_assignment.roleassign
  ]
}

resource "azurerm_role_assignment" "roleassign" {
  count = var.enable_auditing == true ? 1 : 0
  scope                = lookup(var.auditing_settings, "storage_acconut_id", null)
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_mssql_server.mssql.identity[0].principal_id
  depends_on = [
    azurerm_mssql_server.mssql
  ]
}

resource "azurerm_mssql_server_security_alert_policy" "alert_policy" {
  count = var.enable_sql_defender == true ? 1 : 0
  resource_group_name = var.rg_name
  server_name         = var.name
  state               = "Enabled"
  depends_on = [
    azurerm_mssql_server.mssql
  ]
}

resource "azurerm_mssql_server_vulnerability_assessment" "example" {
  count = var.enable_sql_defender == true ? 1 : 0
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.alert_policy[0].id
  storage_container_path          = "${var.sql_defender_settings.primary_blob_endpoint}${var.sql_defender_settings.conainer_name}/"
  storage_account_access_key      = var.sql_defender_settings.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = var.sql_defender_settings.email_subscription_admins
    emails = var.sql_defender_settings.emails
  }
  depends_on = [
    azurerm_mssql_server_security_alert_policy.alert_policy
  ]
}