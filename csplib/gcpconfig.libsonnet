{
  _config+:: {
    local this = self,
    dashboardTags: ['gcp'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    dashboardNamePrefix: 'GCP',
    // UID Prefix for each dashboard
    uid: 'gcp',
    filteringSelector: 'job="integrations/gcp"',

    groupLabels: ['job'],
    instanceLabels: ['bucket_name'],
    metricsSource: 'stackdriver',
    signals:
    {
      blobstore: (import './signals/blobstore.libsonnet')(this),
    },
  }
}