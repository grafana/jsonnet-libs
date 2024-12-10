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

    local importRules(rules) = {
      groups+: std.parseYaml(rules).groups,
    },

    prometheus: {
      alerts: importRules(importstr 'alerts/azure-alerts.yml'),
    },
  },
}
