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
      ARM_SUBSCRIPTION_ID = local.env_config.subscriptions.prod_workloads[0].id
    }
  }
}