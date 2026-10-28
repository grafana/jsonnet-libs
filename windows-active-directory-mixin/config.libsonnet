{
  _config+:: {
    enableADDashboard: true,
    groupLabels: ['job'],
    uid: 'active-directory',
    // The `query` template function is only supported by Prometheus/Mimir (datasource-managed) rule evaluation.
    // Set to false when alerts are installed as Grafana-managed rules, which do not support it.
    alertsQueryTemplateEnabled: true,
  },
}
