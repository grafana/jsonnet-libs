function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'minio_version_info',
    },
    signals: {
      internodeRx: {
        name: 'Internode traffic received',
        nameShort: 'Inbound',
        type: 'counter',
        unit: 'Bps',
        description: 'Internode traffic received, for multi-node clusters. Zero for single node configurations.',
        sources: {
          prometheus: {
            expr: 'internode_rx_bytes_total{%(queriesSelector)s}',
          },
        },
      },
      internodeTx: {
        name: 'Internode traffic sent',
        nameShort: 'Outbound',
        type: 'counter',
        unit: 'Bps',
        description: 'Internode traffic sent, for multi-node clusters. Zero for single node configurations.',
        sources: {
          prometheus: {
            expr: 'internode_tx_bytes_total{%(queriesSelector)s}',
          },
        },
      },
    },
  }
