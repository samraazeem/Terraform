resource "azurerm_servicebus_queue" "service_bus_queue" {
  name                                    = var.service_bus_queue_name
  namespace_id                            = var.service_bus_namespace_id

  lock_duration                           = var.lock_duration
  max_message_size_in_kilobytes           = try(var.max_message_size_in_kilobytes, null)
  max_size_in_megabytes                   = var.max_size_in_megabytes
  requires_duplicate_detection            = var.requires_duplicate_detection
  requires_session                        = var.requires_session
  default_message_ttl                     = try(var.default_message_ttl, null)
  dead_lettering_on_message_expiration    = var.dead_lettering_on_message_expiration
  duplicate_detection_history_time_window = var.duplicate_detection_history_time_window
  max_delivery_count                      = var.max_delivery_count
  status                                  = var.status
  enable_batched_operations               = var.enable_batched_operations
  auto_delete_on_idle                     = try(var.auto_delete_on_idle, null)
  enable_partitioning                     = var.service_bus_sku == "Premium" ? false : try(var.enable_partitioning, false)
  enable_express                          = var.service_bus_sku == "Premium" ? false : try(var.enable_express, false)
  forward_to                              = try(var.forward_to, null)
  forward_dead_lettered_messages_to       = try(var.forward_dead_lettered_messages_to, null)
}