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