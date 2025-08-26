# OpenSearch Module for OCI GenAI Integration Lab

# OpenSearch Cluster
resource "oci_opensearch_opensearch_cluster" "main" {
  compartment_id = var.compartment_id
  display_name   = var.cluster_display_name
  
  # Software version
  software_version = var.opensearch_version
  
  # Master nodes configuration
  master_node_count             = var.master_node_count
  master_node_host_type         = "FLEX"
  master_node_host_ocpu_count   = var.master_node_host_ocpu_count
  master_node_host_memory_gb    = var.master_node_host_memory_gb
  master_node_host_bare_metal_shape = ""
  
  # Data nodes configuration
  data_node_count              = var.data_node_count
  data_node_host_type          = "FLEX"
  data_node_host_ocpu_count    = var.data_node_host_ocpu_count
  data_node_host_memory_gb     = var.data_node_host_memory_gb
  data_node_storage_gb         = var.data_node_storage_gb
  data_node_host_bare_metal_shape = ""
  
  # OpenSearch Dashboard nodes (optional)
  opendashboard_node_count          = 1
  opendashboard_node_host_ocpu_count = 1
  opendashboard_node_host_memory_gb  = 8
  
  # Network configuration
  subnet_compartment_id = var.compartment_id
  subnet_id            = var.subnet_id
  vcn_compartment_id   = var.compartment_id
  vcn_id              = var.vcn_id
  
  # Security
  security_mode                      = "ENFORCING"
  security_master_user_name          = var.admin_username
  security_master_user_password_hash = base64encode(var.admin_password)
  
  # System settings
  #system_memory_percentage = 20
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "opensearch"
  }
  
  lifecycle {
    ignore_changes = [
      security_master_user_password_hash
    ]
  }
}

# Security List for OpenSearch
resource "oci_core_security_list" "opensearch" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.project_name}-opensearch-security-list"
  
  # Egress rules
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }
  
  # Ingress rules for OpenSearch API
  ingress_security_rules {
    source    = "10.0.0.0/24"
    protocol  = "6" # TCP
    stateless = false
    
    tcp_options {
      min = 9200
      max = 9200
    }
  }
  
  # Ingress rules for OpenSearch Dashboards
  ingress_security_rules {
    source    = "10.0.0.0/24"
    protocol  = "6" # TCP
    stateless = false
    
    tcp_options {
      min = 5601
      max = 5601
    }
  }
  
  # Ingress rules for OpenSearch node communication
  ingress_security_rules {
    source    = "10.0.0.0/24"
    protocol  = "6" # TCP
    stateless = false
    
    tcp_options {
      min = 9300
      max = 9300
    }
  }
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "opensearch"
  }
}

# Network Security Group for OpenSearch
resource "oci_core_network_security_group" "opensearch" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.project_name}-opensearch-nsg"
  
  freeform_tags = {
    "Project" = var.project_name
    "Module"  = "opensearch"
  }
}

# NSG Security Rules
resource "oci_core_network_security_group_security_rule" "opensearch_api" {
  network_security_group_id = oci_core_network_security_group.opensearch.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  
  source      = "10.0.0.0/24"
  source_type = "CIDR_BLOCK"
  
  tcp_options {
    destination_port_range {
      max = 9200
      min = 9200
    }
  }
}

resource "oci_core_network_security_group_security_rule" "opensearch_dashboards" {
  network_security_group_id = oci_core_network_security_group.opensearch.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  
  source      = "10.0.0.0/24"
  source_type = "CIDR_BLOCK"
  
  tcp_options {
    destination_port_range {
      max = 5601
      min = 5601
    }
  }
}

resource "oci_core_network_security_group_security_rule" "opensearch_cluster" {
  network_security_group_id = oci_core_network_security_group.opensearch.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  
  source      = "10.0.0.0/24"
  source_type = "CIDR_BLOCK"
  
  tcp_options {
    destination_port_range {
      max = 9300
      min = 9300
    }
  }
}

# Outputs
output "cluster_id" {
  description = "OpenSearch cluster OCID"
  value       = oci_opensearch_opensearch_cluster.main.id
}

output "cluster_endpoint" {
  description = "OpenSearch cluster API endpoint"
  value       = oci_opensearch_opensearch_cluster.main.opensearch_fqdn
}

output "dashboard_endpoint" {
  description = "OpenSearch Dashboards endpoint"
  value       = oci_opensearch_opensearch_cluster.main.opendashboard_fqdn
}

output "cluster_private_ip" {
  description = "OpenSearch cluster private IP"
  value       = oci_opensearch_opensearch_cluster.main.opensearch_private_ip
}

output "dashboard_private_ip" {
  description = "OpenSearch Dashboards private IP"
  value       = oci_opensearch_opensearch_cluster.main.opendashboard_private_ip
}

output "security_list_id" {
  description = "Security list ID for OpenSearch"
  value       = oci_core_security_list.opensearch.id
}

output "network_security_group_id" {
  description = "Network security group ID for OpenSearch"
  value       = oci_core_network_security_group.opensearch.id
}