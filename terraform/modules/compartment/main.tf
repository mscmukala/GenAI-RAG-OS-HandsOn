resource "oci_identity_compartment" "this" {
  name          = var.name
  description   = var.description
  compartment_id = var.parent_compartment_id
  enable_delete = var.enable_delete
}
