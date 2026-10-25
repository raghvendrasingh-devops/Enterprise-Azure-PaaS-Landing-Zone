output "vnet_id" { value = azurerm_virtual_network.paas_vnet.id }
output "integration_subnet_id" { value = azurerm_subnet.app_integration_subnet.id }
output "private_endpoint_subnet_id" { value = azurerm_subnet.private_endpoint_subnet.id }
output "dns_zone_sql_id" { value = azurerm_private_dns_zone.dns_sql.id }
