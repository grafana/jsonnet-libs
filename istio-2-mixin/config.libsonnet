{
  local this = self,
  // Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  filteringSelector: '',
  // Used to identify 'group' of instances.
  groupLabels: ['job', 'cluster'],
  // Istio dashboards are always scoped to a job/cluster rather than to a single
  // scrape target, so there is no instance-level breakdown.
  instanceLabels: [],
  metricsSource: ['prometheus'],

  // Prefix all dashboards uids and alert groups
  uid: 'istio',
  // Prefix for all Dashboards and (optional) rule groups
  dashboardNamePrefix: '',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Alert thresholds
  alertsWarningHighRequestLatency: 4000,  // ms
  alertsWarningGalleyValidationFailures: 0,  // failures per 5m
  alertsCriticalListenerConfigConflicts: 0,  // conflicts per 5m
  alertsWarningXDSConfigRejections: 0,  // rejections per 5m
  alertsCriticalHTTPRequestErrorPercentage: 5,  // %
  alertsCriticalGRPCRequestErrorPercentage: 5,  // %

  // Signal definitions
  signals: {
    overview: (import './signals/overview.libsonnet')(this),
    controlplane: (import './signals/controlplane.libsonnet')(this),
    services: (import './signals/services.libsonnet')(this),
    workloads: (import './signals/workloads.libsonnet')(this),
  },

  // Logs lib related
  // Set to false to disable logs dashboard and logs annotations
  enableLokiLogs: true,
  extraLogLabels: ['pod', 'log_type', 'protocol', 'request_method', 'response_code', 'level'],
  logsVolumeGroupBy: 'response_code',
  showLogsVolume: true,
}
