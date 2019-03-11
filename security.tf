resource "azurerm_resource_group" "igss_security_rg" {
    name = "igss-security-rg"
    location = "${var.region}"

   
  tags {
        project = "${var.project_tag}"
        Environment = "${var.env_tag}"
  }
}

#################
#KeyVault
#################

data "azurerm_client_config" "clientconfig_current" {}

resource "azurerm_key_vault" "igss_keyvault" {
  name                = "igss-keyvault"
  resource_group_name = "${azurerm_resource_group.igss_security_rg.name}"
  location            = "${azurerm_resource_group.igss_security_rg.location}"
 

  sku {
    name = "standard"
  }
  
  tenant_id = "${data.azurerm_client_config.clientconfig_current.tenant_id}"
  
  enabled_for_disk_encryption = true

  tags {
        project = "${var.project_tag}"
        Environment = "${var.env_tag}"
  }
}

resource "azurerm_key_vault_access_policy" "igss_keyvault_accesspolicy02" {
  vault_name          = "${azurerm_key_vault.igss_keyvault.name}"
  resource_group_name = "${azurerm_key_vault.igss_keyvault.resource_group_name}"

  tenant_id = "${data.azurerm_client_config.clientconfig_current.tenant_id}"
  object_id = "${data.azurerm_client_config.clientconfig_current.service_principal_object_id}"

    key_permissions = [

    ]

    secret_permissions = [
      "set",
      "get",
      "delete"
    ]
}

#Devteam_UserGroup
resource "azurerm_key_vault_access_policy" "igss_keyvault_accesspolicy03" {
  vault_name          = "${azurerm_key_vault.igss_keyvault.name}"
  resource_group_name = "${azurerm_key_vault.igss_keyvault.resource_group_name}"

  tenant_id = "${data.azurerm_client_config.clientconfig_current.tenant_id}"
  object_id = "${var.devteam_objectId}"

    key_permissions = [
      "backup", 
      "create", 
      "decrypt", 
      "delete", 
      "encrypt", 
      "get", 
      "import", 
      "list", 
      "purge", 
      "recover", 
      "restore", 
      "sign",
      "unwrapKey", 
      "update", 
      "verify", 
      "wrapKey"
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set"
    ]

    certificate_permissions = [
      "backup", 
      "create", 
      "delete", 
      "deleteissuers", 
      "get", 
      "getissuers", 
      "import", 
      "list", 
      "listissuers", 
      "managecontacts", 
      "manageissuers", 
      "purge", 
      "recover", 
      "restore", 
      "setissuers",
      "update"
    ]

}


resource "azurerm_key_vault_access_policy" "igss_keyvault_accesspolicy04" {
  vault_name          = "${azurerm_key_vault.igss_keyvault.name}"
  resource_group_name = "${azurerm_key_vault.igss_keyvault.resource_group_name}"

  tenant_id = "${data.azurerm_client_config.clientconfig_current.tenant_id}"
  object_id = "${azurerm_function_app.igss_backend_function.identity.principal_id}"

    key_permissions = [
      "get"
    ]

    secret_permissions = [
      "get"
    ]
}