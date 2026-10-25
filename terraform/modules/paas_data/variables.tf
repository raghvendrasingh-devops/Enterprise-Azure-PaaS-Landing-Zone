variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "private_endpoint_subnet_id" { type = string }
variable "tenant_id" { type = string }
variable "sql_server_name" { type = string; default = "sql-paas-enterprise-prod" }
variable "sql_admin_password" { type = string; sensitive = true }
variable "key_vault_name" { type = string; default = "kv-paas-sec-prod-01" }
variable "tags" { type = map(string); default = {} }
