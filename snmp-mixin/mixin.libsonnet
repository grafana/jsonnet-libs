(import 'alerts/alerts.libsonnet') +
{
  grafanaDashboards: {
    'snmp-overview.json': (import 'dashboards/snmp-overview.json'),
  },
}