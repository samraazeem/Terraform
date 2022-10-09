resource "azurerm_servicebus_namespace" "service_bus" {
  name                                    = var.service_bus_name
  location                                = var.location
  resource_group_name                     = var.resource_group_name
  sku                                     = var.service_bus_sku

  dynamic "identity" {
    for_each                              = var.identity != null ? [var.identity] : []
    content {
      type                                = identity.value["type"]
      identity_ids                        = contains(["UserAssigned","SystemAssigned, UserAssigned"], identity.value["type"]) ? try(identity.value["identity_ids"], null) : null
    }
  }

  capacity                                = var.service_bus_sku == "Premium" && var.capacity != null ? var.capacity : 0
  
  dynamic "customer_managed_key" {
    for_each                              = var.customer_managed_key != null ? [var.customer_managed_key] : []
    content {
        key_vault_key_id                  = customer_managed_key.value["key_vault_key_id"]
        identity_id                       = customer_managed_key.value["identity_id"]
        infrastructure_encryption_enabled = customer_managed_key.value["infrastructure_encryption_enabled"]
    }
  }
  
  local_auth_enabled                      = var.local_auth_enabled
  public_network_access_enabled           = var.public_network_access_enabled
  minimum_tls_version                     = var.minimum_tls_version
  zone_redundant                          = var.service_bus_sku == "Premium" && var.zone_redundant != null ? var.zone_redundant : false

  tags                                    = var.tags
}