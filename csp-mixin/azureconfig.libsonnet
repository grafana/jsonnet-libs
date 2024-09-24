{
  _config+:: {
    local this = self,
    dashboardTags: ['azure-cloud-provider'],
    dashboardNamePrefix: 'Azure ',
    blobStorage+: {
      enableAvailability: true,
      bucketLabel: 'resourceName',
    },
    // UID Prefix for each dashboard
    uid: 'azure',
    filteringSelector: 'job="integrations/azure"',

    groupLabels: ['job', 'resourceGroup', 'subscriptionName'],
    instanceLabels: ['resourceName'],
    metricsSource: 'azuremonitor',
    alertAzureVMHighCpuUtilizationThreshold: '80',
    alertAzureVMHighCpuUtilizationSeverity: 'critical',
    alertAzureVMUnavailableSeverity: 'critical',
  },
}
