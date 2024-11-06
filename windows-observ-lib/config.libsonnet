{
  // any modular library should include as inputs:
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
  // 'uid' - UID to prefix all dashboards original uids
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  filteringSelector: 'job=~".*windows.*"',
  dashboardTags: ['windows'],
  uid: 'windows',
  dashboardNamePrefix: '',

  // optional
  ignoreVolumes: 'HarddiskVolume.*',
  alertsCPUThresholdWarning: '90',
  alertMemoryUsageThresholdCritical: '90',
  alertDiskUsageThresholdCritical: '90',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // optional Windows AD
  alertsHighPendingReplicationOperations: 50,  // count
  alertsHighReplicationSyncRequestFailures: 0,  // count
  alertsHighPasswordChanges: 25,  // count
  alertsMetricsDownJobName: 'integrations/windows_exporter',
  enableADDashboard: false,

  // logs lib related
  enableLokiLogs: true,
  extraLogLabels: ['channel', 'source', 'keywords', 'level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
  logsExtraFilters:
    |||
      | label_format timestamp="{{__timestamp__}}"
      | drop channel_extracted,source_extracted,computer_extracted,level_extracted,keywords_extracted
      | line_format `{{ if eq "[[instance]]" ".*" }}{{ alignLeft 25 .instance}}|{{end}}{{alignLeft 12 .channel }}| {{ alignLeft 25 .source}}| {{ .message }}`
    |||,
}
