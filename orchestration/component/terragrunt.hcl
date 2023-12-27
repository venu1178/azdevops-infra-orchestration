locals {
  application             = "azure-orchestration"
  arm_subscription_id = get_env("ARM_SUBSCRIPTION_ID")
  arm_stacc_rg_name         = get_env("ARM_STACC_RG_NAME") 
  arm_stacc_name         = get_env("ARM_STACC_NAME")  
  arm_container       = get_env("ARM_CONTAINER_NAME")
  arm_tenant_id       = get_env("ARM_TENANT_ID") 
}

# Generate an Azure provider block
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults       = false
      purge_soft_delete_on_destroy          = false
      purge_soft_deleted_keys_on_destroy    = false
      purge_soft_deleted_secrets_on_destroy = false
    }
  }
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
  }
  required_version = ">= 1.0.0"
}
EOF
}
remote_state {
  # Disabling since it's causing issues as per
  # https://github.com/gruntwork-io/terragrunt/pull/1317#issuecomment-682041007
  disable_dependency_optimization = true

  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    tenant_id       = local.arm_tenant_id
    subscription_id = local.arm_subscription_id
    resource_group_name  = local.arm_stacc_rg_name
    storage_account_name = local.env_config.global.remote_state.storage_account
    container_name       = local.env_config.global.remote_state.container_name
    key = "${local.application}/terraform.tfstate"
    sas_token            = get_env("ARM_SAS_TOKEN")
  }
}