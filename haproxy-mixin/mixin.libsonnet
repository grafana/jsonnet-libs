{
  grafanaDashboards+:: {
    'haproxy-overview.json': (import 'dashboards/haproxy-overview.jsonnet'),
    'haproxy-frontend.json': (import 'dashboards/haproxy-frontend.jsonnet'),
    'haproxy-backend.json': (import 'dashboards/haproxy-backend.jsonnet'),
    'haproxy-server.json': (import 'dashboards/haproxy-server.jsonnet'),
  },

  prometheusRules+:: (import 'rules/rules.jsonnet'),

  prometheusAlerts+:: (import 'alerts/general.jsonnet'),
}
