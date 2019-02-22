provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
}


resource "azurerm_resource_group" "igss_automation_rg" {
    name = "igss-automation-rg"
    location = "${var.region}"

   
  tags {
        Project = "${var.project_tag}"
        Environment = "${var.env_tag}"
    }
}