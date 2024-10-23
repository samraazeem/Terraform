variable "location" {
  description = "Azure region."
  type = string
}

variable "rg_name" {
  description = "Resource Group."
  type = string
}

variable "name" {
  type = string
  description = "Name of the mssql server."
}

variable "mssql_version" {
  type = string
  description = "Version of the mssql server."
  validation {
    condition = contains(["2.0", "12.0"], var.mssql_version)
    error_message = "Version of mssql server can only be 2.0 and 12.0."
  }
}

variable "administrator_login_password" {
  type = string
  description = "The password associated with the administrator_login user. It is required if azuread_authentication_only if false in azuread_administrator block."
  sensitive = true
  default = null
}

variable "administrator_login" {
  type = string
  description = "The administrator login name for the new server. It is required if azuread_authentication_only if false in azuread_administrator block."
  default = null
}

variable "tags" {
  description = "Tags"
  default = {}
}

variable "azuread_administrator_object" {
  description = "Azure AD administrator block."
  type = string
  default = null
}

variable "azuread_administrator_name" {
  description = "Azure AD administrator block."
  type = string
  default = null
}

variable "connection_policy" {
  type = string
  description = "The connection policy the server will use."
  validation {
    condition = contains(["Default", "Proxy", "Redirect"], var.connection_policy)
    error_message = "The connection policy of mssql server can only be Default, Proxy, and Redirect."
  }
  default = "Default"
}

variable "minimum_tls_version" {
  type = string
  description = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server."
  validation {
    condition = contains(["1.0", "1.1", "1.2", "Disabled"], var.minimum_tls_version)
    error_message = "The minimum_tls_version of mssql server can only be 1.0, 1.1 , 1.2 and Disabled."
  }
  default = "1.2"
}

variable "public_network_access_enabled" {
  type = bool
  description = "Whether public network access is allowed for this server."
  default = true
}

variable "outbound_network_restriction_enabled" {
  type = bool
  description = "Whether outbound network traffic is restricted for this server."
  default = false
}

variable "identity" {
  default = null
  description = "Identity block."
  type = any
}

variable "firewall_rules" {
  description = "Firewall rules for sql server."
  type = list(object({
    name = string
    start_ip_address = string
    end_ip_address = string
  }))
  default = []
}

variable "net_subnets" {
  description = "Network subnets rules."
  type = list(object({
    name = string
    subnet_id = string
  }))
  default = []
}

variable "enable_auditing" {
  description = "Enable SQL Server Auditing."
  default = false
  type = bool
}

variable "auditing_settings" {
  description = "SQL Server Auditing settings."
  default = null
  type = any
}

variable "enable_sql_defender" {
  description = "Enable SQL Server Defender."
  default = false
  type = bool
}

variable "sql_defender_settings" {
  description = "SQL Server Auditing settings."
  default = null
  type = any
}