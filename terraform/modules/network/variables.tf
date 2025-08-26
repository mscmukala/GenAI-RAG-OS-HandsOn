# Variables for Network Module

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "vcn_display_name" {
  description = "Display name for VCN"
  type        = string
}

variable "vcn_cidr_blocks" {
  description = "CIDR blocks for VCN"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "region" {
  description = "OCI Region"
  type        = string
}