##### GENERAL #####
resource_group_name = "rok-rg-123"
location            = "uksouth"

##### LOG ANALYTICS WORKSPACE #####
law_name = "rok-log-analytics-123"
law_sku  = "PerGB2018"

##### APPLICATION INSIGHTS #####
app_insights_name = "rokappinsights123"
app_insights_type = "web"

##### DIAGNOSTIC SETTINGS #####
diagnostic_settings_name = "rok-app-insights-123"

##### APP SERVICE PLAN #####
app_service_plan_name = "rokappserviceplan1234"
app_service_os_type   = "Linux"
app_service_plan_sku  = "B1"

##### AZURE CONTAINER REGISTRY #####
acr_name = "rokacr123"
acr_sku  = "Standard"

##### STORAGE ACCOUNTS #####
function_app_storage_account_name = "roksa123"
storage_account_name              = "appsa123"
storage_account_tier              = "Standard"
storage_account_replication_type  = "LRS"

##### KEY VAULT #####
key_vault_name                            = "rokkv123"
key_vault_sku_name                        = "standard"
key_vault_enabled_for_deployment          = true
key_vault_enabled_for_disk_encryption     = true
key_vault_enabled_for_template_deployment = true
key_vault_soft_delete_retention_days      = 7
key_vault_purge_protection_enabled        = false
key_vault_network_acls = {
  bypass                     = "AzureServices"
  default_action             = "Allow"
  ip_rules                   = []
  virtual_network_subnet_ids = []
}

##### KEY VAULT SECRETS #####
storage_account_connection_string_secret_name = "STORAGE-ACCOUNT-CONNECTION-STRING"
storage_container_secret_name                 = "STORAGE-ACCOUNT-CONTAINER-NAME"
storage_container_name                        = "rok-container-123"

##### FUNCTION APP #####
function_app_name = "rokfuncapp123"
image_name        = "roktestimage123"
image_tag         = "latest"



