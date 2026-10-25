output "app_service_plan_id" { value = azurerm_service_plan.asp.id }
output "web_app_id" { value = azurerm_linux_web_app.web_app.id }
output "web_app_default_hostname" { value = azurerm_linux_web_app.web_app.default_hostname }
output "function_app_id" { value = azurerm_linux_function_app.func.id }
