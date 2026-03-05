function(this) {
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  aggLevel: 'instance',
  aggFunction: 'avg',
  discoveryMetric: 'dragonfly_uptime_in_seconds',
  signals: {
    uptime: {
      name: 'Uptime',
      nameShort: 'Uptime',
      type: 'gauge',
      unit: 's',
      description: 'Dragonfly server uptime in seconds.',
      sources: {
        prometheus: {
          expr: 'dragonfly_uptime_in_seconds{%(queriesSelector)s}',
          legendCustomTemplate: '{{ %s }}' % std.join(' }} - {{ ', this.instanceLabels),
        },
      },
    },

    connectedClients: {
      name: 'Connected clients',
      nameShort: 'Clients',
      type: 'gauge',
      unit: 'short',
      description: 'Number of client connections.',
      sources: {
        prometheus: {
          expr: 'dragonfly_connected_clients{%(queriesSelector)s}',
          legendCustomTemplate: '{{ %s }}' % std.join(' }} - {{ ', this.instanceLabels),
        },
      },
    },

    memoryUtilization: {
      name: 'Memory utilization',
      nameShort: 'Memory %',
      type: 'raw',
      unit: 'percent',
      description: 'Memory used as percentage of max configured.',
      sources: {
        prometheus: {
          expr: '100 * dragonfly_memory_used_bytes{%(queriesSelector)s} / clamp_min(dragonfly_memory_max_bytes{%(queriesSelector)s}, 1)',
          legendCustomTemplate: '{{ %s }}' % std.join(' }} - {{ ', this.instanceLabels),
        },
      },
    },

    commandsRate: {
      name: 'Commands rate',
      nameShort: 'Commands',
      type: 'counter',
      unit: 'ops',
      description: 'Rate of commands processed per second.',
      sources: {
        prometheus: {
          expr: 'rate(dragonfly_commands_total{%(queriesSelector)s}[$__rate_interval])',
          legendCustomTemplate: '{{ %s }}' % std.join(' }} - {{ ', this.instanceLabels),
        },
      },
    },

    keyspaceHitRate: {
      name: 'Keyspace hit rate',
      nameShort: 'Hit rate',
      type: 'raw',
      unit: 'percent',
      description: 'Percentage of keyspace lookups that were hits.',
      sources: {
        prometheus: {
          expr: |||
            100 * rate(dragonfly_keyspace_hits_total{%(queriesSelector)s}[$__rate_interval])
            / clamp_min(
              rate(dragonfly_keyspace_hits_total{%(queriesSelector)s}[$__rate_interval])
              + rate(dragonfly_keyspace_misses_total{%(queriesSelector)s}[$__rate_interval]),
              0.001
            )
          |||,
          legendCustomTemplate: '{{ %s }}' % std.join(' }} - {{ ', this.instanceLabels),
        },
      },
    },

    memoryUsedBytes: {
      name: 'Memory used',
      nameShort: 'Used',
      type: 'gauge',
      unit: 'bytes',
      description: 'Memory used in bytes.',
      sources: {
        prometheus: {
          expr: 'dragonfly_memory_used_bytes{%(queriesSelector)s}',
          legendCustomTemplate: '{{ %s }} - used' % std.join(' }} - {{ ', this.instanceLabels),
        },
      },
    },

    memoryMaxBytes: {
      name: 'Memory max',
      nameShort: 'Max',
      type: 'gauge',
      unit: 'bytes',
      description: 'Maximum memory configured in bytes.',
      sources: {
        prometheus: {
          expr: 'dragonfly_memory_max_bytes{%(queriesSelector)s}',
          legendCustomTemplate: '{{ %s }} - max' % std.join(' }} - {{ ', this.instanceLabels),
        },
      },
    },
  },
}
