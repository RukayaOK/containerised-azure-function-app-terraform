##### GENERAL #####
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region/location"
  type        = string
}

##### LOG ANALYTICS WORKSPACE #####
variable "law_name" {
  description = "Log Analytics Workspace Name"
  type        = string
}

variable "law_sku" {
  description = "Log Analytics Workspace SKU"
  type        = string
}

##### APPLICATION INSIGHTS #####
variable "app_insights_name" {
  description = "App Insights Name"
  type        = string
}

variable "app_insights_type" {
  description = "App Insights Type"
  type        = string
}

##### DIAGNOSTIC SETTINGS #####
variable "diagnostic_settings_name" {
  description = "App Insights Type"
  type        = string
}

##### APP SERVICE PLAN #####
variable "app_service_plan_name" {
  description = "App Service Plan Name"
  type        = string
}

variable "app_service_os_type" {
  description = "App Service Plan OS Type"
  type        = string
}

variable "app_service_plan_sku" {
  description = "App Service Plan SKU"
  type        = string
}

# ##### AZURE CONTAINER REGISTRY #####
variable "ACR_NAME" {
  description = "Azure Container Registry Name"
  type        = string
}

variable "acr_sku" {
  description = "Azure Container Registry SKU"
  type        = string
}

# ##### STORAGE ACCOUNTS #####
variable "function_app_storage_account_name" {
  description = "Funcation App Storage account Name"
  type        = string
}

variable "storage_account_name" {
  description = "Storage Account Name"
  type        = string
}

variable "storage_account_tier" {
  description = "Storage Account Tier"
  type        = string
}

variable "storage_account_replication_type" {
  description = "Storage Account Replication Type"
  type        = string
}

##### KEY VAULT #####
variable "key_vault_name" {
  description = "Key Vault Name"
  type        = string
}

variable "key_vault_sku_name" {
  description = "Key Vault SKU"
  type        = string
}

variable "key_vault_enabled_for_deployment" {
  description = "Key Vault enabled for deployment"
  type        = bool
}

variable "key_vault_enabled_for_disk_encryption" {
  description = "Key Vault enabled for disk encryption"
  type        = bool
}

variable "key_vault_enabled_for_template_deployment" {
  description = "Key Vault enabled for template deployment"
  type        = bool
}

variable "key_vault_soft_delete_retention_days" {
  description = "Key Vault soft retention days"
  type        = number
}

variable "key_vault_purge_protection_enabled" {
  description = "Key Vault purge protection enabled"
  type        = bool
}

variable "key_vault_network_acls" {
  description = "Network rules to apply to key vault."
  type = object({
    bypass                     = string,
    default_action             = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string),
  })
  default = null
}

##### KEY VAULT SECRETS #####
variable "storage_account_connection_string_secret_name" {
  description = "Secret Name for Storage Account Connection String"
  type        = string
}

variable "storage_container_secret_name" {
  description = "Secret Name for Storage Account Container"
  type        = string
}

variable "storage_container_name" {
  description = "Secret Value for Storage Account Container"
  type        = string
}

#### FUNCTION APP #####
variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
}

variable "IMAGE_NAME" {
  description = "Container Image Name"
  type        = string
}

variable "image_tag" {
  description = "Container Image Tag"
  type        = string
}

