variable "location" {
    type = string
    description = "location where the resources are to be deployed"
}
variable "resource_group_name" {
    description = "The resource group name to be imported"
    type        = string
}
variable "tags" {
    type        = map(string)
    description = "Any tags that should be present on the ACR resources"
    default = {}
}
variable "acr_name" {
    type = string
    description = "Specifies the name of the Container Registry"
}
variable "sku" {
    type = string
    description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium"
    validation {
        condition = contains(["Basic", "Standard", "Premium"], var.sku)
        error_message = "AKS SKU can only be Basic, Standard and Premium."
    }
}
variable "admin_enabled" {
    type = bool
    description = "Specifies whether the admin user is enabled."
    default = false
}
variable "public_network_access_enabled" {
    type = bool
    description = "Whether public network access is allowed for the container registry."
    default = true
}
variable "quarantine_policy_enabled" {
    type = bool
    description = "Boolean value that indicates whether quarantine policy is enabled."
    default = false
}
variable "zone_redundancy_enabled" {
    type = bool
    description = "Whether zone redundancy is enabled for this Container Registry? "
    default = false
}
variable "export_policy_enabled" {
    type = bool
    description = "Boolean value that indicates whether export policy is enabled."
    default = true
}
variable "anonymous_pull_enabled" {
    type = bool
    description = "Whether allows anonymous (unauthenticated) pull access to this Container Registry?"
    default = false
}
variable "data_endpoint_enabled" {
    type = bool
    description = "Whether to enable dedicated data endpoints for this Container Registry?"
    default = false
}
variable "network_rule_bypass_option" {
    type = string
    description = "Whether to allow trusted Azure services to access a network restricted Container Registry?"
    default = "AzureServices"
    validation {
        condition = (var.network_rule_bypass_option == null ? true : (contains(["None", "AzureServices"], var.network_rule_bypass_option)))
        error_message = "AKS SKU can only be None and AzureServices."
    }
}
variable "retention_policy" {
    type = any
    description = "Contains the variable for retention policy block"
    default = null
}
variable "trust_policy" {
    type = any
    description = "Contains the variable for trust policy block"
    default = null
}
variable "identity" {
    type = any
    description = "Contains the variable for identity block"
    default = null
}
variable "encryption" {
    type = any
    description = "Contains the variable for encryption block"
    default = null
}
variable "georeplications" {
    type = any
    description = "Contains the variable for georeplications block"
    default = null
}
variable "network_rule_set" {
    type = any
    description = "Contains the variable for network rule set block"
    default = null
}

