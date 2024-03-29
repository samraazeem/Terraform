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
