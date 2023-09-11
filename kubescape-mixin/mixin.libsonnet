{
  grafanaDashboards: {
    'kubescape-overview.json': (import 'dashboards/kubescape-overview.json'),
  },

  // Helper function to ensure that we don't override other rules, by forcing
  // the patching of the groups list, and not the overall rules object.
  local importRules(rules) = {
    groups+: std.parseYaml(rules).groups,
  },

  prometheusAlerts+:
    importRules(importstr 'alerts/kubescape-alerts.yml'),
}
