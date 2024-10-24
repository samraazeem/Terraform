#-----------------------------Resource Groups-----------------------------------------------#
module "resource_groups" {
  source   = "../templates-iac/azurerm/rg"
  for_each = { for rg in var.resource_groups : rg.name => rg }
  rg_name  = each.value.name
  location = lookup(each.value, "location", null) == null ? var.location : each.value.location
  tags     = merge(var.management_common_tags, each.value.tags)
}
#-----------------------------Resource Groups-----------------------------------------------#

module "service_bus" {
  source                                   = "../modules/service_bus/service_bus_namespace"
  for_each                                 = {for sb in var.service_bus_namespaces: sb.service_bus_name => sb}
  service_bus_name                         = each.value.service_bus_name
  location                                 = each.value.location
  resource_group_name                      = module.resource_groups.name
  service_bus_sku                          = each.value.service_bus_sku
  identity                                 = try(each.value.identity, null)
  capacity                                 = try(each.value.capacity, null)
  customer_managed_key                     = try(each.value.customer_managed_key, null)
  local_auth_enabled                       = try(each.value.local_auth_enabled, null)
  public_network_access_enabled            = try(each.value.public_network_access_enabled, null)
  minimum_tls_version                      = try(each.value.minimum_tls_version, null)
  zone_redundant                           = try(each.value.zone_redundant, null)
  tags                                     = merge(try(each.value.tags, null), var.tags)
  depends_on = [
    module.resource_groups
  ]
}

module "kubernetes" {
  source = "../templates-iac/aks"
  for_each = { for kubes in var.kubernetes: kubes.aks_name => kubes }
  aks_name = each.value.aks_name
  location = each.value.location
  rg_name = each.value.rg_name
  aks_ilb_ingress_ip = each.value.aks_ilb_ingress_ip
  nginx_repository = each.value.nginx_repository
  nginx_ingress_name =each.value.nginx_ingress_name
}

resource "null_resource" "helm" {

  provisioner "local-exec" {
    interpreter = ["powershell.exe", "-Command"]
    command = <<-EOT
		  az aks command invoke --resource-group ${var.rg_name} --name ${var.aks_name} --command "helm repo add ${var.nginx_ingress_name} ${var.nginx_repository}; helm repo update; helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.3.0 --create-namespace --namespace ingress-nginx --set controller.service.loadBalancerIP=${var.aks_ilb_ingress_ip} --set controller.service.annotations.'service\.beta\.kubernetes\.io/azure-load-balancer-internal'=true"
    EOT
  }

  # depends_on = [kubectl_manifest.gardener_shoot]
}

# ACR
module "acr" {
  source                        = "../templates-iac/azurerm/acr"
  for_each                      = { for acr in var.containerRegistry : acr.acr_name => acr }
  location                      = var.location
  resource_group_name           = each.value.resource_group_name
  tags                          = merge(var.common_tags, each.value.tags)
  acr_name                      = each.value.acr_name
  sku                           = each.value.sku
  admin_enabled                 = each.value.admin_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  quarantine_policy_enabled     = each.value.quarantine_policy_enabled
  zone_redundancy_enabled       = each.value.zone_redundancy_enabled
  export_policy_enabled         = each.value.export_policy_enabled
  anonymous_pull_enabled        = each.value.anonymous_pull_enabled
  data_endpoint_enabled         = each.value.data_endpoint_enabled
  network_rule_bypass_option    = each.value.network_rule_bypass_option
  retention_policy              = each.value.retention_policy
  trust_policy                  = each.value.trust_policy
  identity                      = each.value.identity
  encryption                    = each.value.encryption
  georeplications               = each.value.georeplications
  network_rule_set              = each.value.network_rule_set
  depends_on = [
    module.resource_groups
  ]
}

#-----------------------------MSSQL Server----------------------------------------------#
module "mssql" {
  source                               = "../templates-iac/azurerm/mssql"
  for_each                             = { for mssql in var.mssql_server : mssql.mssql_server_name => mssql }
  name                                 = each.value.mssql_server_name
  rg_name                              = each.value.rg_name
  location                             = var.location
  mssql_version                        = each.value.mssql_version
  administrator_login                  = lookup(each.value, "administrator_login", null)
  administrator_login_password         = lookup(each.value, "administrator_login_password", null)
  minimum_tls_version                  = lookup(each.value, "minimum_tls_version", "1.2")
  connection_policy                    = lookup(each.value, "connection_policy", "Default")
  tags                                 = merge(var.common_tags, each.value.tags)
  public_network_access_enabled        = lookup(each.value, "public_network_access_enabled", null)
  outbound_network_restriction_enabled = lookup(each.value, "outbound_network_restriction_enabled", null)
  azuread_administrator_object         = lookup(each.value, "azuread_administrator_object", null)
  azuread_administrator_name           = lookup(each.value, "azuread_administrator_name", null)
  identity                             = lookup(each.value, "identity", null)
  firewall_rules                       = lookup(each.value, "firewall_rules", [])
  net_subnets                          = lookup(each.value, "net_subnets", [])
  enable_auditing                      = lookup(each.value, "enable_auditing", false)
  auditing_settings = {
    primary_blob_endpoint = lookup(each.value, "enable_auditing", false) == true ? module.storageaccounts[lookup(each.value, "auditing_storage_account", "")].primary_blob_endpoint : null
    blob_access_key       = null # lookup(each.value,"enable_auditing", false) == true ? module.storageaccounts[lookup(each.value,"auditing_storage_account", "")].primary_access_key : null
    is_secondary_key      = false
    retention_in_days     = lookup(each.value, "auditing_retention_days", 90)
    storage_acconut_id    = lookup(each.value, "enable_auditing", false) == true ? module.storageaccounts[lookup(each.value, "auditing_storage_account", "")].id : null
  }
  enable_sql_defender = lookup(each.value, "enable_sql_defender", false)
  sql_defender_settings = {
    email_subscription_admins = lookup(each.value, "enable_sql_defender", false) == true ? each.value.sql_defender_settings.email_subscription_admins : null
    emails                    = lookup(each.value, "enable_sql_defender", false) == true ? each.value.sql_defender_settings.emails : null
    conainer_name             = lookup(each.value, "enable_sql_defender", false) == true ? each.value.sql_defender_settings.conainer_name : null
    primary_blob_endpoint     = lookup(each.value, "enable_sql_defender", false) == true ? module.storageaccounts[each.value.sql_defender_settings.defender_storage_account].primary_blob_endpoint : null
    primary_access_key        = null #lookup(each.value,"enable_sql_defender", false) == true ? module.storageaccounts[each.value.sql_defender_settings.defender_storage_account].primary_access_key : null
  }
  depends_on = [
    module.resource_groups,
    module.subnets,
    module.storageaccounts
  ]
}
#-----------------------------MSSQL Server----------------------------------------------#