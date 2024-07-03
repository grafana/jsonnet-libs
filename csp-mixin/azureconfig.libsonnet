{
  _config+:: {
    local this = self,
    dashboardTags: ['azure'],
    dashboardNamePrefix: 'Azure ',
    enableAvailability: true,
    bucketLabel: 'resourceName',
    // UID Prefix for each dashboard
    uid: 'azure',
    filteringSelector: 'job="integrations/azure"',

    groupLabels: ['job', 'resourceGroup', 'subscriptionName'],
    instanceLabels: ['resourceName'],
    metricsSource: 'azuremonitor',
  },
}
