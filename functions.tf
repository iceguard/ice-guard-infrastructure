resource "azurerm_resource_group" "igss_businesslogic_rg" {
    name = "igss-businesslogic-rg"
    location = "${var.region}"

    tags {
        project = "${var.project_tag}"
        Environment = "${var.env_tag}"
  }
}

resource "azurerm_storage_account" "igss_businesslogic_function_sa" {
  name                     = "businesslogicfuncsa01"
  resource_group_name      = "${azurerm_resource_group.igss_businesslogic_rg.name}"
  location                 = "${azurerm_resource_group.igss_businesslogic_rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "igss_businesslogic_appplan" {
  name                = "igss-businesslogic-appplan"
  location            = "${azurerm_resource_group.igss_businesslogic_rg.location}"
  resource_group_name = "${azurerm_resource_group.igss_businesslogic_rg.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "igss_businesslogic_function" {
  name                      = "igss-businesslogic-function"
  location                  = "${azurerm_resource_group.igss_businesslogic_rg.location}"
  resource_group_name       = "${azurerm_resource_group.igss_businesslogic_rg.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.igss_businesslogic_appplan.id}"
  storage_connection_string = "${azurerm_storage_account.igss_businesslogic_function_sa.primary_connection_string}"
}


#################
# Backend Function
#################
resource "azurerm_storage_account" "igss_backend_function_sa" {
  name                     = "igssbefuncsa01"
  resource_group_name      = "${azurerm_resource_group.igss_iot_backend_rg.name}"
  location                 = "${azurerm_resource_group.igss_iot_backend_rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_app_service_plan" "igss_backend_appplan" {
  name                = "igss-backend-appplan"

  location            = "${azurerm_resource_group.igss_iot_backend_rg.location}"
  resource_group_name = "${azurerm_resource_group.igss_iot_backend_rg.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}


resource "azurerm_function_app" "igss_backend_function" {
  name                      = "igss-backend-functions"
  location                  = "${azurerm_resource_group.igss_iot_backend_rg.location}"
  resource_group_name       = "${azurerm_resource_group.igss_iot_backend_rg.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.igss_backend_appplan.id}"
  storage_connection_string = "${azurerm_storage_account.igss_backend_function_sa.primary_connection_string}"
  identity   {               
    type = "SystemAsigned"
  }

}