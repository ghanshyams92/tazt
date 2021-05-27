# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A RESOURCE GROUP
# This is an example of how to deploy a Resource Group
# ---------------------------------------------------------------------------------------------------------------------
# See test/azure/terraform_azure_resourcegroup_example_test.go for how to write automated tests for this code.
# ---------------------------------------------------------------------------------------------------------------------

provider "azurerm" {
  version = "~> 2.20"
  features {}
  subscription_id = "a21dced2-2289-4a4a-8aed-142c2c894f9f"
  client_id="52786ff9-f74d-46a2-9fb7-ef3f30e8a6d3"
  client_secret="h6nr8GBRJ9JGHwgB~3fSoq_Q95CQ0UjKuB"
  tenant_id="b65ef724-dcee-4483-b9aa-74adc4cbff1c"


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
