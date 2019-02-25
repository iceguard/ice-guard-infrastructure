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


###################
# Automation Portal
###################

resource "azurerm_automation_account" "igss_automation" {
  name                = "igss-automation"
  location            = "${azurerm_resource_group.igss_automation_rg.location}"
  resource_group_name = "${azurerm_resource_group.igss_automation_rg.name}"

  sku {
    name = "Basic"
  }
}


resource "azurerm_automation_module" "igss_automation_module_azaccounts" {
  name                    = "Az.Accounts"
  resource_group_name     = "${azurerm_resource_group.igss_automation_rg.name}"
  automation_account_name = "${azurerm_automation_account.igss_automation.name}"

  module_link = {
    uri = "https://www.powershellgallery.com/api/v2/package/Az.Accounts/1.2.1"
  }
}
/* 
# TODO: Wait for AZ-Module installation bug
resource "azurerm_automation_module" "igss_automation_module_azStreamAnalytics" {
  name                    = "Az.StreamAnalytics"
  resource_group_name     = "${azurerm_resource_group.igss_automation_rg.name}"
  automation_account_name = "${azurerm_automation_account.igss_automation.name}"

  module_link = {
    uri = "https://www.powershellgallery.com/api/v2/package/Az.StreamAnalytics/1.0.0"
  }

  depends_on = ["azurerm_automation_module.igss_automation_module_azaccounts"]
}
 */
resource "azurerm_automation_schedule" "igss_Automation_schedule01" {
  name                    = "igss-shutdown-schedule"
  resource_group_name     = "${azurerm_resource_group.igss_automation_rg.name}"
  automation_account_name = "${azurerm_automation_account.igss_automation.name}"
  frequency               = "hour"
  interval                = 4
  timezone                = "Central Europe Standard Time"
}

/* 
#Integrate the Runbooks (Automations of AZ Remote Exec must be up and running)

data "local_file" "ps_stop_streamanalytics" {
  filename = "${path.module}/Scripts/Runbooks/Stop-StreamAnalytics.ps1"
}

resource "azurerm_automation_runbook" "example" {
  name                = "Stop-StreamAnalytics.ps1"
  location            = "${azurerm_resource_group.igss_automation_rg.location}"
  resource_group_name = "${azurerm_resource_group.igss_automation_rg.name}"
  account_name        = "${azurerm_automation_account.igss_automation.name}"
  log_verbose         = "true"
  log_progress        = "true"
  description         = "This runbook stops the streamanalytics service to save costs."
  runbook_type        = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-automation-runbook-getvms/Runbooks/Get-AzureVMTutorial.ps1"
  }

  content = "${data.local_file.ps_stop_streamanalytics.content}"
}
 */