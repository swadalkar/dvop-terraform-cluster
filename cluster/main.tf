resource "azurerm_resource_group" "rg_name" {
  name     = var.clustername
  location = "North Europe"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.clustername
  location            = "West US"
  resource_group_name = azurerm_resource_group.rg_name.name
  sku_tier = "Free"
  dns_prefix          = var.clustername
  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    only_critical_addons_enabled = true

  }
  identity { type = "SystemAssigned" }
}

resource "azurerm_kubernetes_cluster_node_pool" "usernodepool" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  mode =  "User"
  tags = {
    Environment = "dev"
  }
}

data "azurerm_container_registry" "container" {
  name            = "dvopsimages"
  resource_group_name = "dvop-registry"
}

resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.container.id
  skip_service_principal_aad_check = true
}