variable "location" { type = string; default = "eastus2" }
variable "tenant_id" { type = string; default = "72f988bf-86f1-41af-91ab-2d7cd011db47" }
variable "sql_admin_password" { type = string; sensitive = true; default = "P@ssw0rdPaaSSecure2026!" }
variable "tags" {
  type = map(string)
  default = {
    Environment = "Production"
    Owner       = "Raghvendra-Singh"
    Tier        = "Enterprise-PaaS-CloudNative"
    ManagedBy   = "Terraform"
  }
}
