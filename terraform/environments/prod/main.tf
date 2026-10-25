terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

resource "azurerm_resource_group" "rg_paas" {
  name     = "rg-enterprise-paas-prod"
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "../../modules/paas_network"
  resource_group_name = azurerm_resource_group.rg_paas.name
  location            = var.location
  vnet_name           = "vnet-paas-cloudnative-prod"
  tags                = var.tags
}

module "compute" {
  source                = "../../modules/paas_compute"
  resource_group_name   = azurerm_resource_group.rg_paas.name
  location              = var.location
  integration_subnet_id = module.network.integration_subnet_id
  tags                  = var.tags
}

module "data" {
  source                     = "../../modules/paas_data"
  resource_group_name        = azurerm_resource_group.rg_paas.name
  location                   = var.location
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  tenant_id                  = var.tenant_id
  sql_admin_password         = var.sql_admin_password
  tags                       = var.tags
}
