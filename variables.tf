# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------
# ARM_CLIENT_ID = "${var.ARM_CLIENT_ID}"
# ARM_CLIENT_SECRET = "${var.ARM_CLIENT_PASSWORD}"
# ARM_SUBSCRIPTION_ID = "${var.ARM_SUBSCRIPTION_ID}"
# ARM_TENANT_ID = "${var.ARM_TENANT_ID}"

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "The location to set for the resource group."
  type        = string
  default     = "East US"
}

variable "postfix" {
  description = "A postfix string to centrally mitigate resource name collisions."
  type        = string
  default     = "resource"
}
