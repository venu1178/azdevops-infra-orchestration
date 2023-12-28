dependency "acr" {
  config_path = "../acr"
}

terraform {
  source = "../../../modules/aks"

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

include  {
  path = find_in_parent_folders()
}