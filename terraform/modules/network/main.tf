# Network Module for OCI GenAI Integration Lab

# VCN
resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_id
  cidr_blocks    = var.vcn_cidr_blocks
  display_name   = var.vcn_display_name
  dns_label      = replace(lower(var.project_name), "-", "")
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-igw"
  enabled        = true
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
  }
}

# NAT Gateway
resource "oci_core_nat_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-nat"
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
  }
}

# Service Gateway
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_service_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-sgw"
  
  services {
    service_id = data.oci_core_services.all_services.services[0].id
  }
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
  }
}

# Public Subnet
resource "oci_core_subnet" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  cidr_block     = var.public_subnet_cidr
  display_name   = "${var.project_name}-public-subnet"
  dns_label      = "public"
  
  prohibit_public_ip_on_vnic = false
  prohibit_internet_ingress   = false
  
  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.public.id]
  dhcp_options_id   = oci_core_vcn.main.default_dhcp_options_id
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
    "Type"    = "public"
  }
}

# Private Subnet
resource "oci_core_subnet" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  cidr_block     = var.private_subnet_cidr
  display_name   = "${var.project_name}-private-subnet"
  dns_label      = "private"
  
  prohibit_public_ip_on_vnic = true
  prohibit_internet_ingress   = true
  
  route_table_id    = oci_core_route_table.private.id
  security_list_ids = [oci_core_security_list.private.id]
  dhcp_options_id   = oci_core_vcn.main.default_dhcp_options_id
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
    "Type"    = "private"
  }
}

# Public Route Table
resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-public-rt"
  
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.main.id
    description       = "Route to Internet Gateway"
  }
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
  }
}

# Private Route Table
resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-private-rt"
  
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.main.id
    description       = "Route to NAT Gateway"
  }
  
  route_rules {
    destination       = data.oci_core_services.all_services.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.main.id
    description       = "Route to Service Gateway"
  }
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
  }
}

# Public Security List
resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-public-sl"
  
  # Egress - Allow all outbound traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }
  
  # Ingress - SSH from anywhere (restrict in production)
  ingress_security_rules {
    source    = "0.0.0.0/0"
    protocol  = "6" # TCP
    stateless = false
    
    tcp_options {
      min = 22
      max = 22
    }
  }
  
  # Ingress - HTTPS from anywhere
  ingress_security_rules {
    source    = "0.0.0.0/0"
    protocol  = "6" # TCP
    stateless = false
    
    tcp_options {
      min = 443
      max = 443
    }
  }
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
  }
}

# Private Security List
resource "oci_core_security_list" "private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-private-sl"
  
  # Egress - Allow all outbound traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }
  
  # Ingress - Allow all from VCN
  ingress_security_rules {
    source    = var.vcn_cidr_blocks[0]
    protocol  = "all"
    stateless = false
  }
  
  # Ingress - SSH from public subnet
  ingress_security_rules {
    source    = var.public_subnet_cidr
    protocol  = "6" # TCP
    stateless = false
    
    tcp_options {
      min = 22
      max = 22
    }
  }
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "network"
  }
}

# Outputs
output "vcn_id" {
  description = "VCN OCID"
  value       = oci_core_vcn.main.id
}

output "vcn_cidr" {
  description = "VCN CIDR blocks"
  value       = oci_core_vcn.main.cidr_blocks
}

output "public_subnet_id" {
  description = "Public subnet OCID"
  value       = oci_core_subnet.public.id
}

output "private_subnet_id" {
  description = "Private subnet OCID"
  value       = oci_core_subnet.private.id
}

output "internet_gateway_id" {
  description = "Internet Gateway OCID"
  value       = oci_core_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "NAT Gateway OCID"
  value       = oci_core_nat_gateway.main.id
}

output "service_gateway_id" {
  description = "Service Gateway OCID"
  value       = oci_core_service_gateway.main.id
}