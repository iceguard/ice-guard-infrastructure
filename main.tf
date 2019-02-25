provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

terraform {
  backend "azurerm" {
  }
}

resource "azurerm_resource_group" "igss_automation_rg" {
    name = "igss-automation-rg"
    location = "${var.region}"

   
  tags {
        Project = "${var.project_tag}"
        Environment = "${var.env_tag}"
    }
}

###################
#Terraform Backend
###################

resource "azurerm_storage_account" "igss_terraform_sa" {
  name                     = "igssterraformsa"
  resource_group_name      = "${azurerm_resource_group.igss_automation_rg.name}"
  location                 = "${azurerm_resource_group.igss_automation_rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"
  
  
  tags {
        Project = "${var.project_tag}"
        Environment = "${var.env_tag}"
  }
}

resource "azurerm_storage_container" "igss_terraform_sa01_container01" {
  name                  = "terraformstatefiles"
  resource_group_name   = "${azurerm_resource_group.igss_automation_rg.name}"
  storage_account_name  = "${azurerm_storage_account.igss_terraform_sa.name}"
  container_access_type = "private"
}