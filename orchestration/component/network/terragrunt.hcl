#include "root" {
#  path = find_in_parent_folders()
#}
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

include  {
  path = find_in_parent_folders()
}

