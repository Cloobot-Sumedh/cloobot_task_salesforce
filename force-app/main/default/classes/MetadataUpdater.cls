public with sharing class MetadataUpdater {
    
    // Invocable method to be called from Flow
    @InvocableMethod(label='Update System Configuration' description='Updates the Is_Active field in a System Configuration metadata record')
    public static void updateSystemConfiguration(List<UpdateRequest> requests) {
        if (requests.isEmpty()) {
            return;
        }
        
        // Process all requests
        for (UpdateRequest req : requests) {
            updateMetadata(req.configName, req.isActive);
        }
    }
    
    // Class to hold request parameters from Flow
    public class UpdateRequest {
        @InvocableVariable(label='Config Name' description='API Name of the configuration record' required=true)
        public String configName;
        
        @InvocableVariable(label='Is Active' description='Whether the configuration should be active' required=true)
        public Boolean isActive;
    }
    
    // Method to update the metadata
    private static void updateMetadata(String fullName, Boolean isActive) {
        // Create metadata container
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        
        // Set up custom metadata to be updated
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        
        // Use the correct namespace and API name format
        // If you don't have a namespace, use: 'System_Configuration__mdt.' + fullName
        customMetadata.fullName = 'System_Configuration__mdt.' + fullName;
        
        // Make sure to set the label (this was missing in your code)
        customMetadata.label = fullName;
        
        // Create the value for the Is_Active field
        Metadata.CustomMetadataValue isActiveField = new Metadata.CustomMetadataValue();
        isActiveField.field = 'Is_Active__c';
        isActiveField.value = isActive;
        
        // Add the field to the metadata
        customMetadata.values.add(isActiveField);
        
        // Add the metadata to the container
        mdContainer.addMetadata(customMetadata);
        
        // Deploy the changes
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
        
        System.debug('Metadata deployment job ID: ' + jobId);
    }
    
    // Optional: Add a callback handler to monitor deployment status
    public class MetadataCallBack implements Metadata.DeployCallback {
        public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
            if (result.status == Metadata.DeployStatus.SUCCEEDED) {
                System.debug('Deployment succeeded');
            } else {
                System.debug('Deployment failed: ' + result.errorMessage);
            }
        }
    }
    
    // Optional: Method to update with callback handler
    public static void updateMetadataWithCallback(String fullName, Boolean isActive) {
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        customMetadata.fullName = 'System_Configuration__mdt.' + fullName;
        customMetadata.label = fullName;
        
        Metadata.CustomMetadataValue isActiveField = new Metadata.CustomMetadataValue();
        isActiveField.field = 'Is_Active__c';
        isActiveField.value = isActive;
        
        customMetadata.values.add(isActiveField);
        mdContainer.addMetadata(customMetadata);
        
        // Deploy with callback
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, new MetadataCallBack());
        
        System.debug('Metadata deployment job ID with callback: ' + jobId);
    }
}