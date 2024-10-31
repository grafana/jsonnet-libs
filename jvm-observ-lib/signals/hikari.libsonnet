local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      java_micrometer: 'hikaricp_connections',  // https://github.com/brettwooldridge/HikariCP/blob/dev/src/main/java/com/zaxxer/hikari/metrics/micrometer/MicrometerMetricsTracker.java
      otel: 'hikaricp_connections',
      otel_with_suffixes: self.otel,
    },
    signals: {
      connections: {
        name: 'Connections',
        description: 'Hikari pool connections',
        type: 'gauge',
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'hikaricp_connections{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          java_micrometer_with_suffixes: self.java_micrometer,
          otel: {
            expr: 'hikaricp_connections{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          otel_with_suffixes: self.otel,
        },
      },
      timeouts: {
        name: 'Connections timeouts',
        description: 'Hikari pool timeouts',
        type: 'counter',
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'hikaricp_connections_timeout_total{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          java_micrometer_with_suffixes: {
            expr: 'hikaricp_connections_timeout{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
        },
      },
      connectionsActive: {
        name: 'Connections (active) ',
        description: 'Hikari pool active connections.',
        type: 'gauge',
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'hikaricp_connections_active{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          java_micrometer_with_suffixes: self.java_micrometer,
          otel: {
            expr: 'hikaricp_connections_active{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          otel_with_suffixes: self.otel,
        },
      },
      connectionsIdle: {
        name: 'Connections (idle) ',
        description: 'Hikari pool idle connections.',
        type: 'gauge',
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'hikaricp_connections_idle{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          java_micrometer_with_suffixes: self.java_micrometer,
          otel: {
            expr: 'hikaricp_connections_idle{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          otel_with_suffixes: self.otel,
        },
      },
      connectionsPending: {
        name: 'Connections (pending) ',
        description: 'Hikari pool pending connections.',
        type: 'gauge',
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'hikaricp_connections_pending{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          java_micrometer_with_suffixes: self.java_micrometer,
          otel: {
            expr: 'hikaricp_connections_pending{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],

          },
          otel_with_suffixes: self.otel,
        },
      },
      connectionsCreationDurationAvg: {
        name: 'Connections creation time (avg)',
        description: 'Hikari pool connection creation time.',
        type: 'raw',
        unit: 's',
        optional: true,
        sources: {
          java_micrometer: {
            expr: |||
              rate(hikaricp_connections_creation_sum{%(queriesSelector)s}[$__rate_interval])
              /rate(hikaricp_connections_creation_count{%(queriesSelector)s}[$__rate_interval])
            |||,
            aggKeepLabels: ['pool'],
          },
          java_micrometer_with_suffixes: {
            expr: |||
              rate(hikaricp_connections_creation_seconds_sum{%(queriesSelector)s}[$__rate_interval])
              /rate(hikaricp_connections_creation_seconds_count{%(queriesSelector)s}[$__rate_interval])
            |||,
            aggKeepLabels: ['pool'],
          },

        },
      },
      connectionsUsageDurationAvg: {
        name: 'Connections usage time (avg)',
        description: 'Hikari pool connection usage time.',
        type: 'raw',
        unit: 's',
        optional: true,
        sources: {
          java_micrometer: {
            expr: |||
              rate(hikaricp_connections_usage_sum{%(queriesSelector)s}[$__rate_interval])
              /rate(hikaricp_connections_usage_count{%(queriesSelector)s}[$__rate_interval])
            |||,
            aggKeepLabels: ['pool'],
          },
          java_micrometer_with_suffixes: {
            expr: |||
              rate(hikaricp_connections_usage_seconds_sum{%(queriesSelector)s}[$__rate_interval])
              /rate(hikaricp_connections_usage_seconds_count{%(queriesSelector)s}[$__rate_interval])
            |||,
            aggKeepLabels: ['pool'],
          },
        },
      },
      connectionsAcquireDurationAvg: {
        name: 'Connections acquire time (avg)',
        description: 'Hikari pool connection acquire time.',
        type: 'raw',
        unit: 's',
        optional: true,
        sources: {
          java_micrometer: {
            expr: |||
              rate(hikaricp_connections_acquire_sum{%(queriesSelector)s}[$__rate_interval])
              /rate(hikaricp_connections_acquire_count{%(queriesSelector)s}[$__rate_interval])
            |||,
            aggKeepLabels: ['pool'],
          },
          java_micrometer_with_suffixes: {
            expr: |||
              rate(hikaricp_connections_acquire_seconds_sum{%(queriesSelector)s}[$__rate_interval])
              /rate(hikaricp_connections_acquire_seconds_count{%(queriesSelector)s}[$__rate_interval])
            |||,
            aggKeepLabels: ['pool'],
          },
        },
      },
      connectionsCreationDurationP95: {
        name: 'Connections creation time (p95)',
        description: 'Hikari pool connection creation time.',
        type: 'histogram',
        unit: 's',
        optional: true,
        sources: {
          otel: {
            expr: 'hikaricp_connections_creation_bucket{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          otel_with_suffixes: {
            expr: 'hikaricp_connections_creation_seconds_bucket{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
        },
      },
      connectionsUsageDurationP95: {
        name: 'Connections usage time (p95)',
        description: 'Hikari pool connection usage time.',
        type: 'histogram',
        unit: 's',
        optional: true,
        sources: {
          otel: {
            expr: 'hikaricp_connections_usage_bucket{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          otel_with_suffixes: {
            expr: 'hikaricp_connections_usage_seconds_bucket{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
        },
      },
      connectionsAcquireDurationP95: {
        name: 'Connections acquire time (p95)',
        description: 'Hikari pool connection acquire time.',
        type: 'histogram',
        unit: 's',
        optional: true,
        sources: {
          otel: {
            expr: 'hikaricp_connections_acquire_bucket{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
          otel_with_suffixes: {
            expr: 'hikaricp_connections_acquire_seconds_bucket{%(queriesSelector)s}',
            aggKeepLabels: ['pool'],
          },
        },
      },
    },
  }
