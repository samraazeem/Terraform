variable "service_bus_queue_name" {
    description = "Specifies the name of the ServiceBus Queue resource."
    type = string
}
variable "service_bus_namespace_id" {
    description = "The ID of the ServiceBus Namespace to create this queue in."
    type = string
}
variable "lock_duration" {
    description = "The lock duration for the subscription as an ISO 8601 duration."
    type = string
    default = "P0DT0H1M0S"
    validation {
        condition = var.lock_duration == null || tonumber(trimsuffix(trimprefix(var.lock_duration == null ? "0" : var.lock_duration, "P0DT0H"), "M0S")) <= 5 
        error_message = "Lock duration should not be more than 5 minutes for Service Bus Subscription."
  }
}
variable "max_message_size_in_kilobytes" {
    description = "Integer value which controls the maximum size of a message allowed on the queue for Premium SKU."
    type = number
}
variable "max_size_in_megabytes" {
    description = "Integer value which controls the size of memory allocated for the queue."
    type = number
    default = 1024
}
variable "requires_duplicate_detection" {
    description = "Boolean flag which controls whether the Queue requires duplicate detection."
    type = bool
    default = false
}
variable "requires_session" {
    description = "Boolean flag which controls whether the Queue requires sessions."
    type = bool
    default = false
}
variable "default_message_ttl" {
    description = "The ISO 8601 timespan duration of the TTL of messages sent to this queue."
    type = string
}
variable "dead_lettering_on_message_expiration" {
    description = "Boolean flag which controls whether the Queue has dead letter support when a message expires."
    type = bool
    default = false
}
variable "duplicate_detection_history_time_window" {
    description = "The ISO 8601 timespan duration during which duplicates can be detected."
    type = string
    default = "PT10M"
}
variable "max_delivery_count" {
    description = "Integer value which controls when a message is automatically dead lettered."
    type = number
    default = 10
}
variable "status" {
    description = "The status of the Queue."
    type = string
    default = "Active"
    validation {
      condition = contains(["Active", "Creating", "Deleting", "ReceiveDisabled", "Disabled", "Renaming", "SendDisabled", "Unknown"], var.status == null ? "Active" : var.status)
      error_message = "Invalid value for status for service bus topic."
    }
}
variable "enable_batched_operations" {
    description = "Boolean flag which controls whether server-side batched operations are enabled."
    type = bool
    default = true
}
variable "auto_delete_on_idle" {
    description = "The idle interval after which the queue is automatically deleted as an ISO 8601 duration."
    type = string
    validation {
        condition = var.auto_delete_on_idle == null || tonumber(trimsuffix(trimprefix(var.auto_delete_on_idle == null ? "0" : var.auto_delete_on_idle, "PT"), "M")) >= 5
        error_message = "Auto Delete interval should be more than 5 minutes for Service Bus Queue."
  }
}
variable "enable_partitioning" {
    description = "Boolean flag which controls whether to enable the queue to be partitioned across multiple message brokers."
    type = bool
    default = false
}
variable "service_bus_sku" {
    description = "SKU for service bus"
    type = string
}
variable "enable_express" {
    description = "Boolean flag which controls whether Express Entities are enabled."
    type = bool
    default = false
}
variable "forward_to" {
    description = "The name of a Queue or Topic to automatically forward messages to."
    type = string
}
variable "forward_dead_lettered_messages_to" {
    description = "The name of a Queue or Topic to automatically forward dead lettered messages to."
    type = string
}
