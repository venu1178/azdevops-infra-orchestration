terraform {
  source = "../../../modules/network"

  extra_arguments "force_subscription" {
    commands = [
      "init",
      "apply",
      "destroy",
      "refresh",
      "import",
      "plan",
      "taint",
      "untaint"
    ]
    env_vars = {
      ARM_SUBSCRIPTION_ID = get_env("ARM_SUBSCRIPTION_ID")
    }
  }
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

include {
  path = find_in_parent_folders()
}