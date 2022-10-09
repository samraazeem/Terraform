variable "service_bus_name" {
    description = "Specifies the name of the ServiceBus Namespace resource"
    type = string
}
variable "location" {
    description = "Specifies the supported Azure location where the resource exists."
    type = string
}
variable "resource_group_name" {
    description = "The name of the resource group in which to create the namespace."
    type = string
}
variable "service_bus_sku" {
    description = "Defines which tier to use."
    type = string
}
variable "identity" {
    description = "specifies the type of Managed Service Identity that should be configured on this API Management Service. Type is required parameter."
    type = any
}
variable "capacity" {
    description = "Specifies the capacity."
    type = number
    default = 0
}
variable "customer_managed_key" {
    description = "specifies customer management key. key_vault_key_id & identity_id is required"
    type = any
}
variable "local_auth_enabled" {
    description = "Whether or not SAS authentication is enabled for the Service Bus namespace."
    type = bool
    default = true
}
variable "public_network_access_enabled" {
    description = "Is public network access enabled for the Service Bus Namespace?"
    type = bool
    default = true
}
variable "minimum_tls_version" {
    description = "The minimum supported TLS version for this Service Bus Namespace."
    type = string
    default = ""
}
variable "zone_redundant" {
    description = "Whether or not this resource is zone redundant. sku needs to be Premium."
    type = bool
    default = false
}
variable "tags" {
    description = " A mapping of tags to assign to the resource."
    type = map
}