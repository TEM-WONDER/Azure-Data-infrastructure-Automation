# creates a resource group in Azure
resource "azurerm_resource_group" "rg" {
  name     = "rg-data-pipeline"
  location = "West Europe"
}

# creates Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                = "kv-datapipeline"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

# creates a role assignment for the Azure Data Factory service principal
resource "azurerm_role_assignment" "adf_access" {
  principal_id         = "your_adf_principal_id"  # Set this to your ADF service principal ID
  role_definition_name = "Contributor"
  scope                = azurerm_resource_group.rg.id
}