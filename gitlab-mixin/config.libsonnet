{
  local this = self,
  filteringSelector: 'job="integrations/gitlab"',
  groupLabels: ['job', 'cluster'],
  logLabels: ['job', 'cluster', 'instance'],
  instanceLabels: ['instance'],

  dashboardTags: [self.uid],
  uid: 'gitlab',
  dashboardNamePrefix: 'GitLab',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: 'prometheus',  // metrics source for signals

  // Multi-cluster support
  enableMultiCluster: false,
  gitlabSelector: if self.enableMultiCluster then 'job=~"$job", instance=~"$instance", cluster=~"$cluster"' else 'job=~"$job", instance=~"$instance"',

  // Logging configuration
  enableLokiLogs: true,
  extraLogLabels: ['level', 'severity'],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
  dashboardRailsExceptionFilename: '/var/log/gitlab/gitlab-rails/exceptions_json.log',
  logExpression: if self.enableMultiCluster then '{job=~"$job", cluster=~"$cluster", instance=~"$instance", exception_class=~".+"} | json | line_format "{{.severity}} {{.exception_class}} - {{.exception_message}}" | drop time_extracted, severity_extracted, exception_class_extracted, correlation_id_extracted'
  else '{filename="' + self.dashboardRailsExceptionFilename + '", job=~"$job", instance=~"$instance"} | json | line_format "{{.severity}} {{.exception_class}} - {{.exception_message}}"',

  // Alerts configuration
  alertsWarningRegistrationFailures: '10',  // %
  alertsWarningRunnerAuthFailures: '10',  // %
  alertsCritical5xxResponses: '10',  // %
  alertsWarning4xxResponses: '10',  // %

  // Signals configuration
  signals+: {
    http: (import './signals/http.libsonnet')(this),
    users: (import './signals/users.libsonnet')(this),
    ci: (import './signals/ci.libsonnet')(this),
  },
}
