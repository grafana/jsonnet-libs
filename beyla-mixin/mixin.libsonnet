{
  grafanaDashboards+:: {
    'beyla_debug.json': (import 'dashboards/beyla_debug.json'),
    'application.json': (import 'dashboards/application.json'),
    'application_process.json': (import 'dashboards/application_process.json'),
  },
  prometheusAlerts+:: (import 'alerts/alerts.libsonnet').prometheusAlerts,
}