variable "name" {
  description = "The name of the compartment."
  type        = string
}

variable "description" {
  description = "The description of the compartment."
  type        = string
  default     = "Managed by Terraform"
}

variable "parent_compartment_id" {
  description = "The OCID of the parent compartment."
  type        = string
}

variable "enable_delete" {
  description = "Whether to enable deletion of the compartment."
  type        = bool
  default     = false
}
