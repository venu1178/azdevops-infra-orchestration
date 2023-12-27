locals {
  application             = "azure-orchestration"
  arm_subscription_id = get_env("ARM_SUBSCRIPTION_ID")
  arm_stacc_rg_name         = get_env("ARM_RG_NAME") 
  arm_stacc_name         = get_env("ARM_STACC_NAME")  
  arm_container       = get_env("ARM_CONTAINER_NAME") 
  arm_tenant_id       = get_env("ARM_TENANT_ID") 
}

 # Remote State Configuration
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
    tenant_id       = "7d3e6cf2-4803-4532-8f1e-708727a21dc2"
    subscription_id = "d4efdad9-9532-492e-87c7-ae99a9fcce15"

    resource_group_name  = "rg_tfstate"
    storage_account_name = "orchestrationtfstate"
    container_name       = "terraformstate"

    key = "${path_relative_from_include()}/terraform.tfstate"

    snapshot = true
  }
}