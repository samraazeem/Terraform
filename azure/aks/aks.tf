resource "azurerm_virtual_network" "vnet" {
  name                = "testt-vnet"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = ["10.194.0.0/16"]
  tags = {
    Environment = "Production"
    Criticality = "low"
    Owner       = "prakhar.bhatia@nagarro.com"
    Project     = "ttx"
    Purpose     = "poc"
  }
}

resource "azurerm_subnet" "subnet" {
  name                      = "testt-subnet"
  resource_group_name       = var.rg_name
  address_prefixes            = ["10.194.0.0/24"]
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = "${azurerm_subnet.subnet.id}"
  }
  network_profile {
      network_plugin = "azure"
      network_policy = "azure"
      service_cidr = "10.1.0.0/16"
      dns_service_ip = "10.1.0.10"
      docker_bridge_cidr = "172.17.0.1/16"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
    Criticality = "low"
    Owner       = "prakhar.bhatia@nagarro.com"
    Project     = "ttx"
    Purpose     = "poc"
  }

  # provisioner "local-exec" {
  #   interpreter = ["powershell.exe", "-Command"]
  #   command = <<-EOT
	# 	  az aks command invoke --resource-group ${var.rg_name} --name ${var.aks_name} --command "helm repo add ${var.nginx_ingress_name} ${var.nginx_repository}; helm repo update; helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.3.0 --create-namespace --namespace ingress-nginx --set controller.service.loadBalancerIP=${var.aks_ilb_ingress_ip} --set controller.service.annotations.'service\.beta\.kubernetes\.io/azure-load-balancer-internal'=true"
  #   EOT
  # }
}

resource "null_resource" "helm" {
  # triggers = {
  #   //shoot_id = kubectl_manifest.gardener_shoot.id
  #   always_run = "${timestamp()}"
  # }

  provisioner "local-exec" {
    interpreter = ["powershell.exe", "-Command"]
    command = <<-EOT
		  az aks command invoke --resource-group ${var.rg_name} --name ${var.aks_name} --command "helm repo add ${var.nginx_ingress_name} ${var.nginx_repository}; helm repo update; helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.3.0 --create-namespace --namespace ingress-nginx --set controller.service.loadBalancerIP=${var.aks_ilb_ingress_ip} --set controller.service.annotations.'service\.beta\.kubernetes\.io/azure-load-balancer-internal'=true"
    EOT
  }

  # depends_on = [kubectl_manifest.gardener_shoot]
}
