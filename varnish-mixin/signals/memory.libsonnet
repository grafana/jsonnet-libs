function(this)
  local legendCustomTemplate = this.legendCustomTemplate;
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'varnish_main_sessions',
    },
    signals: {
      // Memory used
      memoryUsed: {
        name: 'Memory used',
        nameShort: 'Memory',
        type: 'raw',
        description: 'Bytes allocated from Varnish Cache storage.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'varnish_sma_g_bytes{%(queriesSelector)s,type="s0"}',
          },
        },
      },

      // Memory usage percentage
      memoryUsagePercent: {
        name: 'Memory usage percentage',
        nameShort: 'Memory %',
        type: 'raw',
        description: 'Percentage of memory usage.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '(varnish_sma_g_bytes{%(queriesSelector)s,type="s0"} / (varnish_sma_g_bytes{%(queriesSelector)s,type="s0"} + varnish_sma_g_space{%(queriesSelector)s,type="s0"})) * 100',
          },
        },
      },
    },
  }
