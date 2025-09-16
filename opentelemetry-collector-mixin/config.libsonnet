{
  _config+:: {
    // Selector to apply to all dashboard variables, panel queries, alerts and recording rules.
    // Can be used to filter metrics to specific OpenTelemetry Collector instances.
    // Example: 'job="integrations/otel-collector"'
    filteringSelector: '',

    // Labels that represent a group of instances.
    // Used in dashboard variables and alert aggregations.
    // Examples: ['job'] or ['environment', 'job', 'cluster']
    groupLabels: ['job'],

    // Labels that represent a single instance.
    // Used in dashboard variables and legend formats.
    // Examples: ['instance'] or ['instance', 'pod']
    instanceLabels: ['instance'],

    // Grafana dashboard IDs are necessary for stable links for dashboards
    grafanaDashboardIDs: {
      'collector.json': std.md5('collector.json'),
    },

    // Config for the Grafana dashboards in the OpenTelemetry Collector Mixin
    grafana: {
      // The default refresh time for all dashboards, default to 60s
      refresh: '60s',

      // Timezone for Grafana dashboards:: UTC, browser, ...
      grafanaTimezone: 'UTC',

      // Tags for Grafana dashboards
      dashboardTags: ['otelcol'],
    },

    // Default datasource name
    datasourceName: 'default',
  },
}
