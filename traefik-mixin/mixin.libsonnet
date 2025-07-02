{
  grafanaDashboards+:: {
    'traefikdash.json': (import 'dashboards/traefikdash.json'),
  },
} + (import 'alerts/alerts.libsonnet') +
(import 'config.libsonnet')
