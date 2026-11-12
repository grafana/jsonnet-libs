{
  grafanaDashboards+:: {
    'cloudnative-pg.json': (import 'dashboards/cloudnative-pg.json'),
  },

  prometheusAlerts+:: std.parseYaml(importstr 'alerts/alerts.yaml'),
}
