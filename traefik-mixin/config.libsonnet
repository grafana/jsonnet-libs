{
  _config+:: {
    // alerts thresholds
    traefik_tls_expiry_days_critical: 7,
    traefik_tls_expiry_days_warning: 14,
    timeSeriesLabels: '',
    // Example:
    // timeSeriesLabels: "component=\"traefik\",environment=\"production\"",
    // for config alert
    sumByLabels: 'instance',
    // for TLS alerts
    maxByLabels: 'sans',
    alertLabels: {},
    // Example:
    // alertLabels: {
    //   environment: 'production',
    //   component: 'traefik',
    // },
    alertAnnotations: {},
    // Example:
    // alertAnnotations: {
    //   runbook: 'https://runbooks.example.com/traefik-tls',
    //   grafana: 'https://grafana.example.com/d/traefik',
    // },
  },
}
