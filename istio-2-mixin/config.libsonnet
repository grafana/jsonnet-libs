{
  // Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  filteringSelector: 'job=~"integrations/istio"',
  // Used to identify 'group' of instances.
  groupLabels: ['job', 'cluster'],

  // Prefix all dashboards uids and alert groups
  uid: 'istio',
  // Prefix for all Dashboards and (optional) rule groups
  dashboardNamePrefix: '',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Alert thresholds
  alertsWarningHighCPUUsage: 70,  //%
  alertsCriticalHighCPUUsage: 90,  //%
  alertsWarningHighRequestLatency: 4000,
  alertsWarningGalleyValidationFailures: 0,
  alertsCriticalListenerConfigConflicts: 0,
  alertsWarningXDSConfigRejections: 0,
  alertsCriticalHTTPRequestErrorPercentage: 5,  //%
  alertsCriticalGRPCRequestErrorPercentage: 5,  //%

  // Logs lib related
  // Set to false to disable logs dashboard and logs annotations
  enableLokiLogs: true,
  extraLogLabels: ['pod', 'log_type', 'protocol', 'request_method', 'response_code', 'level'],
  logsVolumeGroupBy: 'response_code',
  showLogsVolume: true,
}
