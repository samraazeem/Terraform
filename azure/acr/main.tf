resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  quarantine_policy_enabled = var.quarantine_policy_enabled
  zone_redundancy_enabled = var.zone_redundancy_enabled
  export_policy_enabled = var.export_policy_enabled
  anonymous_pull_enabled = var.anonymous_pull_enabled
  data_endpoint_enabled = var.data_endpoint_enabled
  network_rule_bypass_option = var.network_rule_bypass_option
  tags = var.tags
  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? ["retention_policy"] : []
    content {
      days = lookup(var.retention_policy, "days", 7)
      enabled = lookup(var.retention_policy, "enabled", null)
    }
  }

  dynamic "trust_policy" {
    for_each = var.trust_policy != null ? ["trust_policy"] : []
    content {
      enabled = lookup(var.trust_policy, "enabled", null)
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? ["identity"] : []
    content {
      type = var.identity["identity_type"]
      identity_ids = lookup(var.identity, "identity_ids", null)
    }
  }

  dynamic "encryption" {
    for_each = var.encryption != null ? ["encryption"] : []
    content {
      enabled = lookup(var.encryption, "enabled", null)
      key_vault_key_id = var.encryption["key_vault_key_id"]
      identity_client_id = var.encryption["identity_client_id"]
    }
  }

  dynamic "georeplications" {
    for_each = var.georeplications == null ? [] : var.georeplications
    content {
      location                = georeplications.value.regional_endpoint_location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      tags                    = georeplications.value.regional_endpoint_tags
    }
  }

  dynamic "network_rule_set" {
    for_each = var.network_rule_set != null ? ["network_rule_set"] : []
    content {
      default_action = lookup(var.network_rule_set, "default_action", "Allow")
      dynamic "ip_rule" {
        for_each = var.network_rule_set["ip_rule"] == null ? [] : var.network_rule_set["ip_rule"]
        content {
          action = ip_rule.value.action
          ip_range = ip_rule.value.iprange
        }
      }
      dynamic "virtual_network" {
        for_each = var.network_rule_set["virtual_network"] == null ? [] : var.network_rule_set["virtual_network"]
        content {
          action = virtual_network.value.action
          subnet_id = virtual_network.value.subnet_id
        }
      }
    }
  }
}