{
  grafanaDashboards: {
    'rabbitmq-overview.json': (import 'dashboards/rabbitmq-overview.json'),
    'erlang-memory-allocators.json': (import 'dashboards/erlang-memory-allocators.json'),
  },

  // Helper function to ensure that we don't override other rules, by forcing
  // the patching of the groups list, and not the overall rules object.
  local importRules(rules) = {
    groups+: std.parseYaml(rules).groups,
  },

  prometheusAlerts+:
    importRules(importstr 'alerts/clusterAlerts.yaml'),
}
