{
  _config+:: {
    // Grafana dashboard IDs are necessary for stable links for dashboards
    grafanaDashboardIDs: {
      'collector.json': std.md5('collector.json'),
    },

    // Config for the Grafana dashboards in the Kubernetes Mixin
    grafana: {
      // The default refresh time for all dashboards, default to 10s
      refresh: '10s',

      // Timezone for Grafana dashboards:: UTC, browser, ...
      grafanaTimezone: 'UTC',

      // Tags for Grafana dashboards
      dashboardTags: ['otelcol'],
    },

    // Default datasource name
    datasourceName: 'default',
  },
}
