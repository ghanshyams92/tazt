# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A RESOURCE GROUP
# This is an example of how to deploy a Resource Group
# ---------------------------------------------------------------------------------------------------------------------
# See test/azure/terraform_azure_resourcegroup_example_test.go for how to write automated tests for this code.
# ---------------------------------------------------------------------------------------------------------------------

provider "azurerm" {
  version = "~> 2.20"
  features {}
  subscription_id = "${var.ARM_SUBSCRIPTION_ID}"
  client_id       = "${var.ARM_CLIENT_ID}"
  client_secret   = "${var.ARM_CLIENT_PASSWORD}"
  tenant_id       = "${var.ARM_TENANT_ID}"
}

# PIN TERRAFORM VERSION

terraform {
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.12.26"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A RESOURCE GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "resource_group" {
  name     = "terratest-rg-${var.postfix}"
  location = var.location
}
