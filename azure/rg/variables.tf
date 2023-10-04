variable "location" {
  description = "Azure region to use"
  type        = string
}

variable "rg_name" {
  description = "Resource Group Name"
  type        = string
}

variable "tags" {
  description = "Resource Group Tags"
  type        = map
  default     = {}
}