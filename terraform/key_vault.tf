resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku_name

  enabled_for_deployment          = var.key_vault_enabled_for_deployment
  enabled_for_disk_encryption     = var.key_vault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  purge_protection_enabled        = var.key_vault_purge_protection_enabled

  dynamic "network_acls" {
    for_each = var.key_vault_network_acls != null ? [true] : []
    content {
      bypass                     = var.key_vault_network_acls.bypass
      default_action             = var.key_vault_network_acls.default_action
      ip_rules                   = var.key_vault_network_acls.ip_rules
      virtual_network_subnet_ids = var.key_vault_network_acls.virtual_network_subnet_ids
    }
  }
}

resource "azurerm_key_vault_access_policy" "function_app" {
  key_vault_id = azurerm_key_vault.main.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_linux_function_app.main.identity[0].principal_id

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Recover",
    "Restore",
    "Set",
    "Purge"
  ]
  key_permissions         = []
  certificate_permissions = []
  storage_permissions     = []
}

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Recover",
    "Restore",
    "Set",
    "Purge"
  ]
  key_permissions         = []
  certificate_permissions = []
  storage_permissions     = []
}


resource "azurerm_key_vault_secret" "storage_account_connection_string_secret" {
  name         = var.storage_account_connection_string_secret_name
  value        = azurerm_storage_account.main.primary_connection_string
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]
}

resource "azurerm_key_vault_secret" "storage_container_secret" {
  name         = var.storage_container_secret_name
  value        = var.storage_container_name
  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]
}
