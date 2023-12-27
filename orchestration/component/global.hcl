locals {
  application             = "azure-orchestration"
  arm_subscription_id = get_env("ARM_SUBSCRIPTION_ID")
  arm_rg_name         = get_env("ARM_RG_NAME") 
  arm_stacc_name         = get_env("ARM_STACC_NAME")  
  arm_container       = get_env("ARM_CONTAINER_NAME")
  arm_tenant_id       = get_env("ARM_TENANT_ID") 
}