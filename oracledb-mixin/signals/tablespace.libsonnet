function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + this.tablespaceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'oracledb_tablespace_bytes',
    },
    signals: {
      tablespaceUsed: {
        name: 'Tablespace used bytes',
        nameShort: 'Used bytes',
        type: 'gauge',
        description: 'Tablespace used bytes.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'oracledb_tablespace_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ tablespace }} - used',
          },
        },
      },
      tablespaceFree: {
        name: 'Tablespace free bytes',
        nameShort: 'Free bytes',
        type: 'gauge',
        description: 'Tablespace free bytes.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'oracledb_tablespace_free{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ tablespace }} - free',
          },
        },
      },
      tablespaceMax: {
        name: 'Tablespace max bytes',
        nameShort: 'Max bytes',
        type: 'gauge',
        description: 'Tablespace maximum bytes.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'oracledb_tablespace_max_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ tablespace }} - max',
          },
        },
      },
    },
  }
