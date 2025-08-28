# Hands-on Lab Playbook  

## Lab Title  
**Developing a GenAI Agent using OCI RAG with OpenSearch as the Knowledge Base**  

### 1. Infrastructure Setup  
#### Pre-provision Infrastructure
Considering the amount of time taken to create OCI services using Terraform, some of the larger services and permissions will be pre-provisioned before the workshop.

The following services are pre-provisioned:

- **OCI OpenSearchDB:** Used to store vector embeddings to perform semantic search  
  [Reference](https://docs.oracle.com/en/learn/oci-opensearch/index.html#introduction)
- **OCI Network:** For simplicity, creating one VCN with public and private subnets along with required gateways  
  [Reference](https://docs.oracle.com/en/solutions/wls-on-prem-to-oci/use-wizard-create-vcn.html)
- **OCI Policies:** Required access permissions for services to access  
  Reference: `/data/policies`
### 2. User Provision and Access

How users will access the environment:

- Users work within the defined tenancy (**Srinivas Tenancy** will be used).
- Access will be provided a couple of hours before the demo.
- **Each participant must provide their full name and email.**
- Users will receive an email once provisioned and given appropriate access.
- Users log in with the provided credentials.
### 3. Create Compartment 
```sh
oci iam compartment list --name "handson-root" --all
```
----
```sh
oci iam compartment create --compartment-id <handson-root-ocid> --name <sub-compartment-name> --description "<description of sub-compartment>"
```

### 4. Create a Notebook Session

Login to the OCI console and perform the following steps:

**Step 1:**  
Navigate to:  
`Analytics & AI` → `Machine Learning` → `Data Science`

**Step 2:**  
When creating the session, use the following settings:
- **Compartment:** Choose the newly created compartment
- **Name:** `<name of your choice>`
- **Compute shape:** `<shape of your choice>` (or leave as default)
- **Custom networking:**
  - **Compartment:** `handson-root`
  - **VCN:** `handson-vcn`
  - **Subnet:** `private subnet-handson-vcn`
- Leave the rest as default
- **Under Runtime configuration section:**
  - Add Git settings:
    - Click **+ Add Git settings**
    - **Git repo URL:** `https://github.com/mscmukala/GenAI-RAG-OS-HandsOn.git`

**Step 3:**  
Click **Create**

> **Note:** Notebook creation may take at least 6–7 minutes. Please be patient.

### 5. Execution

Follow these steps to run the hands-on portion of the lab:

1. In the notebook session, under **Launcher**, find and open **Jupyter**.
2. Open the **Notebook session**.
3. Find the Git repo added during notebook session creation.
4. Navigate to the `data-process-execution.ipynb` file.
5. Execute the notebook cells in sequence, following the instructions within.

### 6. GenAI Agent Creation

Login to the OCI console and perform the following steps:

**Step 1:**  
Navigate to:  
`Analytics & AI` → `Generative AI Agents`

**Step 2:**  
On the left, select **Overview**.  
In the center of the page, click **Get Started: Create your first agent** → **Create Agent**.

**Step 3:**  
Fill in the basic information:
- **Name:** `<of your choice>`
- **Compartment:** Choose the newly created compartment  
Leave the rest of the values as defaults.  
Click **Next**.

**Step 4:**  
Add Tool:
- Click **Add tool**
  - Ensure **RAG** is selected
  - Under **RAG configuration**:
    - **Name:** `<of your choice>`
    - **Description:**  
      `Use knowledgebase to provide advanced medical reasoning. Researches solutions to provided questions which are verifiable medical problems. Those responses are validated through a medical practitioner.`

**Step 5:**  
Set compute and networking:
- **Compute shape:** `<shape of your choice>` (or leave as default)
- **Custom networking:**
  - **Compartment:** `handson-root`
  - **VCN:** `handson-vcn`
  - **Subnet:** `private subnet-handson-vcn`
- Leave all other settings as default

**Step 6:**  
Click **Create**

### 7. Perform Conversational Chat

1. Go back to the **Agents** listing screen.
2. Find the agent you created above.
3. Click **Launch Chat**.
4. Enter your diagnostic query, for example:

   > Given a patient with sudden neurological symptoms after long-distance travel and evidence of leg swelling, what cardiac abnormality could explain these findings?
### Summary

By completing this lab, you will have:

- **Understood** the OCI AI services required to build a solution around a medical diagnosis helper for medical professionals.
- **Set up and executed** a Jupyter Notebook to interact with the GenAI Agent.
- **Performed semantic search** using OpenSearch as a knowledge base.