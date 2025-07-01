{
  grafanaDashboards+:: {
    'traefikdash.json': (import 'dashboards/traefikdash.json'),
  },
  prometheusAlerts+:: (import 'alerts/alerts.libsonnet'),
}
