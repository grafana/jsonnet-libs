{
  _config+:: {
    enableMultiCluster: false,
    gitlabSelector: if self.enableMultiCluster then 'job=~"$job", instance=~"$instance", cluster=~"$cluster"' else 'job=~"$job", instance=~"$instance"',

    dashboardTags: ['gitlab-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    dashboardRailsExceptionFilename: '/var/log/gitlab/gitlab-rails/exceptions_json.log',
    logExpression: if self.enableMultiCluster then 'job=~"$job", instance=~"$instance", cluster=~"$cluster"' else '{filename="'+ self.dashboardRailsExceptionFilename +'", ' + self.gitlabSelector +'} | json | line_format "{{.severity}} {{.exception_class}} - {{.exception_message}}"',

    // for alerts
    alertsWarningRegistrationFailures: '10',  // %
    alertsWarningRunnerAuthFailures: '10',  // %
    alertsCritical5xxResponses: '10',  // %
    alertsWarning4xxResponses: '10',  // %

    // enable Loki logs
    enableLokiLogs: true,
  },
}
