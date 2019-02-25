resource "azurerm_resource_group" "igss_iot_backend_rg" {
    name = "igss-iot-backend-rg"
    location = "${var.region}"

    tags {
        project = "${var.project_tag}"
        Environment = "${var.env_tag}"
  }
}

#IoT-Hub SA Endpoint
resource "azurerm_storage_account" "igss_iotmessages_sa01" {
  name                     = "igssiotmsgsa01"
  resource_group_name      = "${azurerm_resource_group.igss_iot_backend_rg.name}"
  location                 = "${azurerm_resource_group.igss_iot_backend_rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
        project = "${var.project_tag}"
        Environment = "${var.env_tag}"
  }
}

resource "azurerm_key_vault_secret" "igss_iotmessages_sa01_endpoint" {
  name      = "igssiotmsgsa01-endpoint"
  value     = "${azurerm_storage_account.igss_iotmessages_sa01.primary_blob_endpoint}"
  vault_uri = "${azurerm_key_vault.igss_keyvault.vault_uri}"
  depends_on = ["azurerm_key_vault_access_policy.igss_keyvault_accesspolicy02"]
}

resource "azurerm_key_vault_secret" "igss_iotmessages_sa01_secret" {
  name      = "igssiotmsgsa01-secret"
  value     = "${azurerm_storage_account.igss_iotmessages_sa01.primary_access_key}"
  vault_uri = "${azurerm_key_vault.igss_keyvault.vault_uri}"
  depends_on = ["azurerm_key_vault_access_policy.igss_keyvault_accesspolicy02"]
}

resource "azurerm_storage_container" "igss_iotmessages_sa01_container01" {
  name                  = "igsssa01container01"
  resource_group_name   = "${azurerm_resource_group.igss_iot_backend_rg.name}"
  storage_account_name  = "${azurerm_storage_account.igss_iotmessages_sa01.name}"
  container_access_type = "private"
}

resource "azurerm_iothub" "igss_iothub" {
  name                = "igss-iothub"
  resource_group_name = "${azurerm_resource_group.igss_iot_backend_rg.name}"
  location            = "${azurerm_resource_group.igss_iot_backend_rg.location}"

  sku {
    name     = "F1"
    tier     = "Free"
    capacity = "1"
  }

  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    connection_string          = "${azurerm_storage_account.igss_iotmessages_sa01.primary_blob_connection_string}"
    name                       = "export"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    container_name             = "${azurerm_storage_container.igss_iotmessages_sa01_container01.name}"
    encoding                   = "Avro"
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  }

  route {
    name           = "export"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export"]
    enabled        = true
  }

  tags {
        project = "${var.project_tag}"
        Environment = "${var.env_tag}"
  }
}


##################
# Stream Analytics
##################
# Not possible to deploy native in Terrafrom at the moment. Workaround ARM Template:

resource "azurerm_template_deployment" "igss_streamanalyitics_deployment" {
  name                = "StreamAnalytics-Deployment-01"
  resource_group_name = "${azurerm_resource_group.igss_iot_backend_rg.name}"
  template_body       = "${file("${path.cwd}/StreamAnalytics/StreamAnalytics.json")}"

  parameters {
    name = "igss-streamanalytics"
    location = "${azurerm_resource_group.igss_iot_backend_rg.location}"
    apiVersion = "2017-04-01-preview"
    sku = "standard"
    jobType = "Cloud"
  }

  deployment_mode = "Incremental"
  depends_on      = ["azurerm_iothub.igss_iothub"]
}


