# OCI Provider Configuration

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 7.14.0"
    }
    # local = {
    #   source  = "hashicorp/local"
    #   version = ">= 2.12.0"
    # }
    # archive = {
    #   source  = "hashicorp/archive"
    #   version = ">= 2.0.0"
    # }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid  
  region           = var.region
}

provider "local" {
  # No configuration needed
}

provider "archive" {
  # No configuration needed
}