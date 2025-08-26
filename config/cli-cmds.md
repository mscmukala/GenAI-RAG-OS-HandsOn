
# OCI CLI Commands: Create Sub-Compartment under 'handson-root'

# 1. Get the OCID of the parent compartment (handson-root)
oci iam compartment list --name "handson-root" --all

# 2. Create a sub-compartment under 'handson-root'
oci iam compartment create \
	--compartment-id <handson-root-ocid> \
	--name <sub-compartment-name> \
	--description "<description of sub-compartment>"

# Example:
# oci iam compartment create \
#   --compartment-id ocid1.compartment.oc1..aaaaaaaaxxxxxxxx \
#   --name my-sub-compartment \
#   --description "Sub-compartment for GenAI project"


# ---
# Cleanup: Delete Sub-Compartment

# 1. Get the OCID of the sub-compartment you want to delete
oci iam compartment list --name <sub-compartment-name> --all

# 2. Delete the sub-compartment (moves to DELETING state)
oci iam compartment delete --compartment-id <sub-compartment-ocid>

# 3. (Optional) Verify deletion status
oci iam compartment get --compartment-id <sub-compartment-ocid>

# Note: A compartment must be empty (no resources) before it can be deleted.
