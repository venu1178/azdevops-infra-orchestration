locals {
  application             = "azure-orchestration"
  arm_subscription_id = get_env("ARM_SUBSCRIPTION_ID")
  arm_stacc_rg_name         = get_env("ARM_RG_NAME") 
  arm_stacc_name         = get_env("ARM_STACC_NAME")  
  arm_container       = get_env("ARM_CONTAINER_NAME") 
  arm_tenant_id       = get_env("ARM_TENANT_ID") 

  #ADO vars
  ado_pat_token     = get_env("PAT")
  organization_name = get_env("ADO_ORGANIZATION")
  ado_org_url       = "https://dev.azure.com/${local.organization_name}/"
}

# Generate an Azure provider block
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
provider "azuredevops" {
  personal_access_token = "${local.ado_pat_token}"
  org_service_url =  "${local.ado_org_url}"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">= 0.3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0.1"
    }
  }
  required_version = ">= 1.0.0"
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
 # Remote State Configuration
remote_state {
  backend = "azurerm"
  config  = {
    subscription_id      = local.arm_subscription_id
    resource_group_name  = local.arm_stacc_rg_name
    storage_account_name = local.arm_stacc_name
    container_name       = local.arm_container
    key                  = "${path_relative_to_include()}/${local.application}.tfstate"
    //sas_token            = get_env("BACKEND_SAS_TOKEN")
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}