{
  _config+:: {
    local this = self,
    dashboardPeriod: 'now-1h',
    dashboardTags: ['gcp-cloud-provider'],
    dashboardNamePrefix: 'GCP ',
    blobStorage+: {
      bucketLabel: 'bucket_name',
    },
    gcploadBalancer+: {
      backendLabel: 'backend_target_name',
      countryLabel: 'client_country',
    },

    // UID Prefix for each dashboard
    uid: 'gcp',
    filteringSelector: 'job="integrations/gcp"',

    groupLabels: ['job'],
    instanceLabels: ['bucket_name'],
    metricsSource: 'stackdriver',
    local importRules(rules) = {
      groups+: std.parseYaml(rules).groups,
    },

    prometheus: {
      alerts: importRules(importstr 'alerts/gcp-alerts.yml'),
      recordingRules: {},
    },
  },
}
