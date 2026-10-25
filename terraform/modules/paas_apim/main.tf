terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "Enterprise Platform Team"
  publisher_email     = "architecture@enterprise.com"
  sku_name            = "Developer_1"

  virtual_network_type = "Internal" # Fully Private API Gateway

  virtual_network_configuration {
    subnet_id = var.apim_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Global Security Policy: Rate Limiting & Zero-Trust Headers
resource "azurerm_api_management_policy" "global_policy" {
  api_management_id = azurerm_api_management.apim.id

  xml_content = <<XML
<policies>
    <inbound>
        <rate-limit calls="100" renewal-period="60" />
        <check-header name="X-Correlation-ID" failed-check-httpcode="400" failed-check-error-message="Missing Correlation ID" ignore-case="true" />
        <cors>
            <allowed-origins>
                <origin>*</origin>
            </allowed-origins>
            <allowed-methods>
                <method>GET</method>
                <method>POST</method>
                <method>PUT</method>
                <method>DELETE</method>
            </allowed-methods>
        </cors>
    </inbound>
    <backend>
        <forward-request timeout="30" />
    </backend>
    <outbound>
        <set-header name="X-Content-Type-Options" exists-action="override">
            <value>nosniff</value>
        </set-header>
    </outbound>
    <on-error />
</policies>
XML
}
