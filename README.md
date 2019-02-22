# infrastructure
Build your Azure resources with Terraform / ARM Templates

## Getting Started
1. Install Terraform
```
https://learn.hashicorp.com/terraform/getting-started/install.html
```
2. Create terraform.tfvars file form terraform.tfvars.template for secure file upload into pipeline or local storage (excluded from git).
3. Provide Tenant, Subscription and Client ID and Client Secret of account to use for Azure provider.
4. Provde Backend configuration (Azure Blob Storage in this example. For further details visit: https://www.terraform.io/docs/backends/config.html)
5. Configure ID for Team you want to give full access on key vault.
