provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}

terraform{
    backend "azurerm" {
    storage_account_name = "${var.storage_account_name}"
    container_name       = "${var.container_name}"
    key                  = "${var.key}"
    access_key           = "${var.access_key}"
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