{
  local this = self,
  // any modular library should include as inputs:
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
  // 'uid' - UID to prefix all dashboards original uids
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="windows"
  dashboardTags: ['windows'],
  uid: 'windows',
  dashboardNamePrefix: '',

  // 'prometheus_pre_0_30' points to old metrics schema prior to breaking changes in windows_exporter v0.30.0,
  // 'prometheus_pre_0_31' points to metrics schema from v0.30.0 to v0.31.0,
  // 'prometheus' points to current metrics schema (v0.31.0+, Alloy v1.11+).
  // Use any of the above or combination based on your exporter version.
  metricsSource: ['prometheus', 'prometheus_pre_0_31', 'prometheus_pre_0_30'],

  // optional
  ignoreVolumes: 'HarddiskVolume.*',
  alertsCPUThresholdWarning: '90',
  alertMemoryUsageThresholdCritical: '90',
  alertDiskUsageThresholdCritical: '90',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // optional Windows AD
  alertsHighPendingReplicationOperations: '50',  // count
  alertsHighReplicationSyncRequestFailures: '0',  // count
  alertsHighPasswordChanges: '25',  // count
  alertsMetricsDownJobName: 'integrations/windows_exporter',
  enableADDashboard: false,

  // logs lib related
  enableLokiLogs: true,
  extraLogLabels: ['channel', 'source', 'keywords', 'level'],
  logsVolumeGroupBy: 'level',
  logsGroupLabels: this.groupLabels,
  logsInstanceLabels: this.instanceLabels,
  logsFilteringSelector: this.filteringSelector,
  showLogsVolume: true,
  logsExtraFilters:
    |||
      | label_format timestamp="{{__timestamp__}}"
      | drop channel_extracted,source_extracted,computer_extracted,level_extracted,keywords_extracted
      | line_format `{{ if eq "[[instance]]" ".*" }}{{ alignLeft 25 .instance}}|{{end}}{{alignLeft 12 .channel }}| {{ alignLeft 25 .source}}| {{ .message }}`
    |||,

  signals+: {
    system: (import './signals/system.libsonnet')(this),
    cpu: (import './signals/cpu.libsonnet')(this),
    memory: (import './signals/memory.libsonnet')(this),
    disk: (import './signals/disk.libsonnet')(this),
    network: (import './signals/network.libsonnet')(this),
    services: (import './signals/services.libsonnet')(this),
    activeDirectory: (import './signals/activeDirectory.libsonnet')(this),
    alerts: (import './signals/alerts.libsonnet')(this),
    logs: (import './signals/logs.libsonnet')(this),
  },
}
