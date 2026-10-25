variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "integration_subnet_id" { type = string }
variable "app_service_plan_name" { type = string; default = "asp-paas-linux-prod" }
variable "web_app_name" { type = string; default = "app-enterprise-core-prod-01" }
variable "func_storage_name" { type = string; default = "safuncpaasprodsec01" }
variable "function_app_name" { type = string; default = "func-enterprise-events-prod" }
variable "tags" { type = map(string); default = {} }
