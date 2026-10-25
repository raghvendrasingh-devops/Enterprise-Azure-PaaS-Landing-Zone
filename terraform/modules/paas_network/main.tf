terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

resource "azurerm_virtual_network" "paas_vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
  tags                = var.tags
}

# 1. Delegated Subnet for App Service VNet Integration
resource "azurerm_subnet" "app_integration_subnet" {
  name                 = "snet-appsvc-integration"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.paas_vnet.name
  address_prefixes     = [var.integration_subnet_prefix]

  delegation {
    name = "delegation-appservice"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# 2. Subnet for Private Endpoints
resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "snet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.paas_vnet.name
  address_prefixes     = [var.pe_subnet_prefix]
}

# 3. Centralized Private DNS Zones
resource "azurerm_private_dns_zone" "dns_sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_sql" {
  name                  = "link-sql-paas-vnet"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_sql.name
  virtual_network_id    = azurerm_virtual_network.paas_vnet.id
}
