#!/usr/bin/env python3
"""
Salesforce Deployment Script (Fixed Authentication)
"""

import subprocess
import sys
import json
from getpass import getpass

# Configuration
CREDENTIALS = {
    "source": {
        "username": "sumedhdeshkar825@agentforce.com",
        "password": "Bharat@2002",
        "security_token": "qxclDKJVvdpgsbvEw76hzBsJ6"
    },
    "target": {
        "username": "sumedh867@agentforce.com",
        "password": "Bharat@2002",
        "security_token": "DPT7OUXnCpeNHrDkvnfRhnqgf"
    }
}

COMPONENTS = {
    "flows": ["systemconfig_flow_sumedh"],
    "apex_classes": ["MetadataUpdater"],
    "custom_metadata": ["System_Configuration__mdt"]
}

def run_command(command, org_alias=None):
    """Execute SFDX command with error handling"""
    try:
        full_cmd = f"sfdx {command}" + (f" -u {org_alias}" if org_alias else "")
        result = subprocess.run(
            full_cmd,
            shell=True,
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"\nError executing: {e.cmd}")
        print(f"Status Code: {e.returncode}")
        print(f"Error Output:\n{e.stderr}")
        sys.exit(1)

def authenticate_org(org_type):
    """Authenticate using web-based OAuth flow"""
    print(f"\nAuthenticating {org_type} org...")
    run_command(f"force:auth:web:login --setalias {org_type}_org")
    
    # Verify authentication
    result = json.loads(run_command(f"force:org:display --json", f"{org_type}_org"))
    print(f"Authenticated as: {result['result']['username']}")

def deploy_process():
    """Main deployment workflow"""
    print("=== Salesforce Deployment Process ===")
    
    # Authenticate to both orgs
    authenticate_org("source")
    authenticate_org("target")
    
    # Retrieve components
    print("\nRetrieving components from source org...")
    metadata_types = []
    for flow in COMPONENTS["flows"]:
        metadata_types.append(f"Flow:{flow}")
    for apex_class in COMPONENTS["apex_classes"]:
        metadata_types.append(f"ApexClass:{apex_class}")
    for md in COMPONENTS["custom_metadata"]:
        metadata_types.append(f"CustomObject:{md}")
    
    run_command(
        f"force:source:retrieve -m \"{','.join(metadata_types)}\" -u source_org"
    )
    
    # Deploy components
    print("\nDeploying to target org...")
    run_command(
        "force:source:deploy -p ./force-app/main/default -w 60 -u target_org"
    )
    
    # Verification
    print("\nVerifying deployment...")
    flow_result = json.loads(run_command(
        f"force:data:soql:query -q \"SELECT Id FROM Flow WHERE DeveloperName = '{COMPONENTS['flows'][0]}'\" --json -u target_org"
    ))
    print(f"Found {len(flow_result['result']['records'])} deployed flow instances")
    
    print("\n=== Deployment Completed Successfully ===")

if __name__ == "__main__":
    deploy_process()