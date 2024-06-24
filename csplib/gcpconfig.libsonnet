{
  _config+:: {
    local this = self,
    dashboardPeriod: 'now-1h',
    dashboardTags: ['gcp'],
    dashboardNamePrefix: 'GCP ',
    // UID Prefix for each dashboard
    uid: 'gcp',
    filteringSelector: 'job="integrations/gcp"',

    groupLabels: ['job'],
    instanceLabels: ['bucket_name'],
    metricsSource: 'stackdriver',
  },
}
