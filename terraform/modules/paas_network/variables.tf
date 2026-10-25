variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string; default = "vnet-spoke-paas-prod" }
variable "address_space" { type = string; default = "172.16.32.0/20" }
variable "integration_subnet_prefix" { type = string; default = "172.16.32.0/24" }
variable "pe_subnet_prefix" { type = string; default = "172.16.33.0/24" }
variable "tags" { type = map(string); default = {} }
