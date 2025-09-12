# Hands-on Lab Playbook  

## Lab Title: **Developing a GenAI Agent using OCI RAG with OpenSearch as the Knowledge Base**  

### 1. Infrastructure Setup  
#### Pre-provision Infrastructure
Considering the amount of time taken to create OCI services using Terraform, some of the larger services and permissions will be pre-provisioned before the workshop.

The following services are pre-provisioned:

- **OCI OpenSearchDB:** Used to store vector embeddings to perform semantic search  
  [Reference](https://docs.oracle.com/en/learn/oci-opensearch/index.html#introduction)
- **OCI Network:** For simplicity, creating one VCN with public and private subnets along with required gateways  
  [Reference](https://docs.oracle.com/en/solutions/wls-on-prem-to-oci/use-wizard-create-vcn.html)
- **OCI Vault:** For simplicity, create vault  
  [Reference](https://docs.oracle.com/en-us/iaas/Content/KeyManagement/Tasks/managingvaults_topic-To_create_a_new_vault.htm)
- **OCI Policies:** Required access permissions for services to access  
  Reference: `/config/policies`
### 2. User Provision and Access

How users will access the environment:

- Users work within the defined tenancy (**Workshop Tenancy** will be used).
- Access will be provided a couple of hours before the demo.
- **Each participant must provide their full name and email.**
- Users will receive an email once provisioned and given appropriate access.
- Users log in with the provided credentials.
### 3. Create Compartment 

Login to the OCI console and perform the following steps:

**Step 1:**  
Navigate to:  
`Identity & Security` → Under 'Identity' → Click `Compartments`

**Step 2:**  
- Click on compartment titled: **handson-root**
- Click **Create compartment**
- Fill in the details:
  - **Name:** `<name of your choice>`
  - **Description:** `<enter description>`
  - **Parent compartment:** Ensure **handson-root** is selected
- Click **Create Compartment**

### 4. Create a Notebook Project 
Login to the OCI console and perform the following steps:
**Navigate to:**  
  `Analytics & AI` → `Machine Learning` → `Data Science`
  Find and Click "Create Project" on the center screen
    - Use following settings:
      - **Compartment:** '<Choose the newly created compartment>'
      - **Name**:** `<name of your choice>`
    - Click **Create** button

### 5. Create a Notebook Session
**Step 1:**  
On left top corner navigation, should see as follows: 
'Data Science` >> `Projects` >> `Project Details`

**Step 2:**
- Find and Click on **Create Notebook Session"
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
  **Note:** Notebook creation may take at least 6–7 minutes. Please be patient.

**Step 4:** 
Once Notebook session created, look for "Open" at the center left , this will open in seperate window where you have to login to tenancy again. 

Once login you should see datascience notebook session.

### 6. Execution
Follow these steps to run the hands-on portion of the lab:

1. In the notebook session, on left menu, click on repos folder, keep navigating till you find folder "notebooks"
2. Find python nookbook file, data-processing-execution.ipynb and double click the file
3. On the pop-up "Select Kernel" , in the dropdown choose Python[conda env:root]* , click "Select"
4. Instrcutor will help executing the notebook cells...

### 7. GenAI Agent Creation

Login to the OCI console and perform the following steps:

**Step 1:**  
Navigate to:  
`Analytics & AI` → under AI Services section click `Generative AI Agents`

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
  - Under **Add knowledge bases**:
    - **Compartment:** Your newly created compartment should already be selected
    - Click **Create Knowledge base**
    - In the **New Knowledge base** window:
      - **Name:** `<of your choice>`
      - **Compartment:** Leave as is
      - **Data source type:** Select `OCI OpenSearch` from dropdown
      - **OpenSearch Cluster compartment:** Change to `handson-root`
      - **OpenSearch Cluster:** Select `os-cluster-handson-pre` from dropdown
      - Under **OpenSearch Index** section:
        - **Index Name:** `<put the index name created in the notebook session>`
        - **Body Key:** `text`
      - Under **Secret Details** section:
        - Select **Basic Auth Secret**
        - **Basic Auth vault Secret compartment:** Change to `handson-root`
        - Select `secret-os-creds` from dropdown
    - Click **Create** 
- Back in the **Add Tool** window: wait unitl Knowledge base "Lifecycle    status" shows 'Active'
  - Select the checkbox next to your newly created Knowledge base
  - Click **Add tool**

**Step 5:**  
- Back in the create Agent window, click **Next**
- In the **Setup agent endpoint** window:
  - Leave all fields at their default values
  - Click **Next**

**Step 6:**  
- Click **Create Agent**
- In the popup, accept the license agreement and click "Submit"


### 8. Perform Conversational Chat

1. Go back to the **Agents** listing screen.
2. Find the agent you created above.
3. Click **Launch Chat**.
4. Enter your diagnostic query, for example:

   > A patient with pre-existing cardiac disease presents with complaints of sudden, involuntary jerks occurring during ambulation. What are the possible differential diagnoses? 

5. For more sample prompts , please refer to section "Sample Prompts for Various Scenarios" in the Introduction.md

### Summary

By completing this lab, you will have:

- **Understood** the OCI AI services required to build a solution around a medical diagnosis helper for medical professionals.
- **Set up and executed** a Jupyter Notebook to interact with the GenAI Agent.
- **Performed semantic search** using OpenSearch as a knowledge base.

[def]: https://docs.oracle.com/en/solutions/wls-on-prem-to-oci/use-wizard-create-vcn.html