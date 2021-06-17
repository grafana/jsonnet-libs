{
  grafanaDashboards: {
    'jira-overview.json': (import 'dashboards/jira-overview.json'),
  },

  // Helper function to ensure that we don't override other alerts, by forcing
  // the patching of the groups list, and not the overall alert object.
  local importAlerts(alerts) = {
    groups+: std.native('parseYaml')(alerts)[0].groups,
  },

  prometheusAlerts+:
    importAlerts(importstr 'alerts/general.yaml')
}
