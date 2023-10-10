local config = (import 'config.libsonnet');

{
  grafanaDashboards:
    if config._config.enableLokiLogs then
      {
        'asterisk-overview.json': (import 'dashboards/asterisk-overview.json'),
        'asterisk-logs.json': (import 'dashboards/asterisk-logs.json'),
      }
    else
      {
        'asterisk-overview.json': (import 'dashboards/asterisk-overview.json'),
      },

  // Helper function to ensure that we don't override other rules, by forcing
  // the patching of the groups list, and not the overall rules object.
  local importRules(rules) = {
    groups+: std.parseYaml(rules).groups,
  },

  prometheusAlerts+:
    importRules(importstr 'alerts/asteriskAlerts.yaml'),
}
