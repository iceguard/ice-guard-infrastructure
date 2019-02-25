variable "subscription_id" {
  type        = "string"
  description = "Subscription id"
}

variable "tenant_id" {
  type        = "string"
  description = "Tenant id"
}

variable "client_id" {
  type        = "string"
  description = "Client id"
}

variable "client_secret" {
  type        = "string"
  description = "Client secret"
}

variable "region" {
    description = "Region to deploy the environment into."
    default = "westeurope"
}

variable "project_tag" {
    description = "Project tag."
    default = "PSIT4"
}

variable "env_tag" {
    description = "Environment tag."
    default = "Development"
}

variable "devteam_objectId" {
    description = "Object ID of group to enable full access on keyvault for development purposes. Defined in terraform.tfvars"
}