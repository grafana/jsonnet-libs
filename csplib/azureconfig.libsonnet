{
  _config+:: {
    local this = self,
    dashboardTags: ['azure'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    dashboardNamePrefix: 'Azure ',
    // UID Prefix for each dashboard
    uid: 'azure',
    filteringSelector: 'job="integrations/azure"',

    groupLabels: ['job', 'resourceGroup', 'subscriptionName'],
    instanceLabels: ['resourceName'],
    metricsSource: 'azuremonitor',
    signals:
      {
        blobstore: (import './signals/blobstore.libsonnet')(this),
      },
  },
}
