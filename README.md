
# Salesforce Metadata Deployment Script

This script automates the process of retrieving specific components from a **source Salesforce org** and deploying them to a **target Salesforce org** using the Salesforce CLI (SFDX).

## Prerequisites

- [Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli) installed
- Python 3.x installed
- Active source and target Salesforce developer orgs
- Security tokens added to the password if necessary

---

## ⚙️ Setup Instructions

1. **Install Salesforce CLI**  
   Follow the official guide:  
   👉 https://developer.salesforce.com/tools/sfdxcli

2. **Create a Salesforce Project**

   Open terminal and run:
   ```bash
   sfdx force:project:create --projectname YourProjectName
   cd YourProjectName
   ```

3. **Place Script in Root Directory**

   Copy the `deploy.py` file into the **root directory** of your newly created Salesforce project.

4. **Update Credentials**

   In `deploy.py`, modify the `SOURCE_CREDS` and `TARGET_CREDS` dictionary with your Salesforce org credentials:
   ```python
   SOURCE_CREDS = {
       "username": "your_source_username",
       "password": "your_source_password",
       "security_token": "your security token",
       "alias": "source_org"
   }

   TARGET_CREDS = {
       "username": "your_target_username",
       "password": "your_target_password",
       "security_token": "your security token",
       "alias": "target_org"
   }
   ```
   also PUT usernames IN deploy_process() function at place of source_org and target_org respectively
5. **Assign Components to Deploy**

   Update the `COMPONENTS` dictionary to define which flows, Apex classes, or metadata you want to transfer:
   ```python
   COMPONENTS = {
       "flows": ["Your_Flow_Name"],
       "apex_classes": ["YourApexClass"],
       "custom_metadata": ["Your_Metadata_Object"]
   }
   ```

---

## 🚀 Running the Script

Simply run the script:

```bash
python3 deploy.py
```

---

## 🧠 What Happens

- Authenticates to **source** and **target** orgs
- Retrieves specified components from the **source org**
- Validates and deploys them to the **target org**
- Verifies deployment success with SOQL queries
- Extracted components will appear in:
  ```
  ./force-app/main/default
  ```
- Target org will reflect all deployed components

---

