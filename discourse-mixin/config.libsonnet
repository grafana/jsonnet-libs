{
  local this = self,

  // Filtering
  filteringSelector: 'job="integrations/discourse"',
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
    overview: (import './signals/overview.libsonnet')(this),
    jobs: (import './signals/jobs.libsonnet')(this),
  },
}
