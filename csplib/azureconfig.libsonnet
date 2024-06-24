{
  _config+:: {
    local this = self,
    dashboardTags: ['azure'],
    dashboardNamePrefix: 'Azure ',
    // UID Prefix for each dashboard
    uid: 'azure',
    filteringSelector: 'job="integrations/azure"',

    groupLabels: ['job', 'resourceGroup', 'subscriptionName'],
    instanceLabels: ['resourceName'],
    metricsSource: 'azuremonitor',
  },
}
