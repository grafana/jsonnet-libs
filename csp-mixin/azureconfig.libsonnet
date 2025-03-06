{
  _config+:: {
    local this = self,
    dashboardTags: ['azure-cloud-provider'],
    dashboardNamePrefix: 'Azure ',
    blobStorage+: {
      enableAvailability: true,
      bucketLabel: 'resourceName',
    },
    commomVars+: {
      groupLabel: 'resourceGroup',
      subscriptionLabel: 'subscriptionName',
      instanceLabel: 'resourceName',
      dimensionEndpoint: 'dimensionEndpoint',
    },
    // UID Prefix for each dashboard
    uid: 'azure',
    filteringSelector: 'job="integrations/azure"',

    groupLabels: ['job', 'resourceGroup', 'subscriptionName'],
    instanceLabels: ['resourceName'],
    metricsSource: ['azuremonitor', 'azuremonitor_agentless'],

    local importRules(rules) = {
      groups+: std.parseYaml(rules).groups,
    },

    prometheus: {
      alerts: importRules(importstr 'alerts/azure-alerts.yml'),
    },
  },
}
