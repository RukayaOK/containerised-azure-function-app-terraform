output "acr_server" {
  value = azurerm_container_registry.main.login_server
}

output "image_name" {
  value = var.image_name
}