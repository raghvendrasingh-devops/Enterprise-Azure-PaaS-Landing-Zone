output "sql_server_id" { value = azurerm_mssql_server.sql.id }
output "sql_server_fqdn" { value = azurerm_mssql_server.sql.fully_qualified_domain_name }
output "key_vault_id" { value = azurerm_key_vault.kv.id }
