variable "rg_name" {
  default = "rg_network"
}

variable "rg_location" {
  default = "uksouth"
}
variable "name" {
type=string
description="Name for this infrastructure"
default = "vnet_network"
}

variable "address_space" {
  type        = string
  description = "Cidr range for the Virtual Network"
  default     = "10.10.0.0/16"
}

variable "tags" {
  type        = map(string)
