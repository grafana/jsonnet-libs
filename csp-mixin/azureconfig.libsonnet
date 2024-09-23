{
  _config+:: {
    local this = self,
    dashboardTags: ['azure-cloud-provider'],
    dashboardNamePrefix: 'Azure ',
    blobStorage+: {
      enableAvailability: true,
      bucketLabel: 'resourceName',
    },
    azurevm+: {
      groupLabel: 'resourceGroup',
      subscriptionLabel: 'subscriptionName',
      instanceLabel: 'resourceName',
    },
    // UID Prefix for each dashboard
    uid: 'azure',
    filteringSelector: 'job="integrations/azure"',

    groupLabels: ['job', 'resourceGroup', 'subscriptionName'],
    instanceLabels: ['resourceName'],
    metricsSource: 'azuremonitor',
    alertAzureVMAvailableMemoryLowThreshold: '367001600',
    alertAzureVMAvailableMemoryLowSeverity: 'critical',
  },
}
