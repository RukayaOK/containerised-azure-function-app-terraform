
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = var.app_service_os_type
  sku_name            = var.app_service_plan_sku
}


# Create an Azure Function App
resource "azurerm_linux_function_app" "main" {
  name                        = var.function_app_name
  resource_group_name         = azurerm_resource_group.main.name
  location                    = var.location
  service_plan_id             = azurerm_service_plan.main.id
  storage_account_name        = azurerm_storage_account.function_app.name
  storage_account_access_key  = azurerm_storage_account.function_app.primary_access_key
  functions_extension_version = "~4"
  site_config {
    container_registry_use_managed_identity = true
    application_insights_connection_string  = azurerm_application_insights.main.connection_string
    application_insights_key                = azurerm_application_insights.main.instrumentation_key
    always_on                               = true
    application_stack {
      docker {
        registry_url = azurerm_container_registry.main.login_server
        image_name   = var.image_name
        image_tag    = var.image_tag
      }
    }
  }
  app_settings = {
    "AzureWebJobsStorage"                                        = azurerm_storage_account.function_app.primary_connection_string
    "AzureWebJobsDashboard"                                      = azurerm_storage_account.function_app.primary_connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"                             = azurerm_application_insights.main.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"                      = azurerm_application_insights.main.connection_string
    "WEBSITE_LOGGING_LOG_LEVEL"                                  = "Information"
    "AzureFunctionsJobHost__Logging__Console__IsEnabled"         = "true"
    "AzureFunctionsJobHost__Logging__Console__LogLevel__Default" = "Information"
    "STORAGE_ACCOUNT_CONNECTION_STRING"                          = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.storage_account_connection_string_secret_name})"
    "STORAGE_CONTAINER_NAME"                                     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.storage_container_secret_name})"
    "SCALE_CONTROLLER_LOGGING_ENABLED"                           = "AppInsights:Verbose"
    "DOCKER_REGISTRY_SERVER_URL"                                 = azurerm_container_registry.main.login_server
    "DOCKER_ENABLE_CI"                                           = true
    "FUNCTIONS_EXTENSION_VERSION"                                = "~4"
    "DOCKER_CUSTOM_IMAGE_NAME"                                   = "DOCKER|${azurerm_container_registry.main.login_server}/${var.image_name}:latest"
    "DOCKER_REGISTRY_SERVER_USERNAME"                            = null
    "DOCKER_REGISTRY_SERVER_PASSWORD"                            = null
    "WEBSITE_WEBDEPLOY_USE_SCM"                                  = true
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"                        = false
  }

  identity {
    type = "SystemAssigned"
  }
}
