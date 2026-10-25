variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "apim_subnet_id" { type = string }
variable "apim_name" { type = string; default = "apim-enterprise-core-prod" }
variable "tags" { type = map(string); default = {} }
