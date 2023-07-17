# Create an Azure Log Analytics workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = var.law_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.law_sku
}

resource "azurerm_application_insights" "main" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = var.app_insights_type
}

# Connect the Azure Function App to Application Insights
resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = var.diagnostic_settings_name
  target_resource_id         = azurerm_linux_function_app.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  log {
    category = "FunctionAppLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
