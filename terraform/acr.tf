resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false
}

resource "azurerm_role_assignment" "pull_image" {
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.main.id
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id
}

resource "azurerm_container_registry_webhook" "webhook" {
  # No dashes allowed in the name
  name                = "${replace(lower(azurerm_linux_function_app.main.name), "/\\W|_|\\s/", "")}webhook"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  registry_name       = azurerm_container_registry.main.name

  service_uri = "https://${azurerm_linux_function_app.main.site_credential[0].name}:${azurerm_linux_function_app.main.site_credential[0].password}@${lower(azurerm_linux_function_app.main.name)}.scm.azurewebsites.net/api/registry/webhook"
  status      = "enabled"
  scope       = "${var.image_name}:latest"
  actions     = ["push"]
  custom_headers = {
    "Content-Type" = "application/json"
  }
}