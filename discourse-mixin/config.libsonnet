{
  local this = self,

  // Filtering
  filteringSelector: 'job=~"$job", instance=~"$instance"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],

  // Dashboard settings
  dashboardTags: ['discourse-mixin'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  dashboardNamePrefix: 'Discourse',
  uid: 'discourse',

  // Logs configuration
  enableLokiLogs: false,

  // Alert thresholds
  alertsCritical5xxResponses: 10,  // %
  alertsWarning4xxResponses: 30,  // %

  // Metrics source
  metricsSource: 'prometheus',

  // Signal categories
  signals: {
    http: (import './signals/http.libsonnet')(this),
    requests: (import './signals/requests.libsonnet')(this),
    jobs: (import './signals/jobs.libsonnet')(this),
    memory: (import './signals/memory.libsonnet')(this),
  },
}
