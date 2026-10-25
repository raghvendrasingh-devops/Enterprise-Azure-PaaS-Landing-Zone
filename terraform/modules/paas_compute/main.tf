terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

# 1. App Service Plan Linux
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "P1v3"
  tags                = var.tags
}

# 2. Linux Web App with Regional VNet Integration
resource "azurerm_linux_web_app" "web_app" {
  name                = var.web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.asp.id
  https_only          = true

  public_network_access_enabled = false # Zero Public Exposure

  virtual_network_subnet_id = var.integration_subnet_id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on        = true
    ftps_state       = "Disabled"
    minimum_tls_version = "1.2"

    application_stack {
      node_version = "20-lts"
    }
  }

  tags = var.tags
}

# 3. Storage Account for Serverless Functions
resource "azurerm_storage_account" "func_sa" {
  name                     = var.func_storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

# 4. Serverless Linux Function App
resource "azurerm_linux_function_app" "func" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = azurerm_storage_account.func_sa.name
  storage_account_access_key = azurerm_storage_account.func_sa.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id
  https_only                 = true

  virtual_network_subnet_id = var.integration_subnet_id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    ftps_state       = "Disabled"
    minimum_tls_version = "1.2"
    application_stack {
      python_version = "3.11"
    }
  }

  tags = var.tags
}
