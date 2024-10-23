output "id" {
  value = azurerm_mssql_server.mssql.id
  description = "MS SQL Id."
}

output "fully_qualified_domain_name" {
  value = azurerm_mssql_server.mssql.fully_qualified_domain_name
  description = "The fully qualified domain name of the Azure SQL Server (e.g. myServerName.database.windows.net)"
}

