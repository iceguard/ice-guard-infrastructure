resource "azurerm_resource_group" "igss_automation_rg" {
    name = "igss-automation-rg"
    location = "${var.igss_region}"

   
  tags {
        Project = "${var.igss_project_tag}"
        Environment = "${var.igss_env_tag}"
    }
}