function(this) {
  local aggregationLabels = '(' + std.join(',', this.groupLabels + this.instanceLabels + ['partition']) + ')',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'group',
  aggFunction: 'sum',
  alertsInterval: '5m',
  discoveryMetric: 'bigip_node_status_availability_state',
  signals: {
    // Cluster availability metrics
    nodeAvailability: {
      name: 'Node availability',
      nameShort: 'Node availability',
      type: 'raw',
      description: 'The percentage of nodes available.',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum by ' + aggregationLabels + ' (bigip_node_status_availability_state{%(queriesSelector)s}) / clamp_min(count by ' + aggregationLabels + ' (bigip_node_status_availability_state{%(queriesSelector)s}),1)',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },

    poolAvailability: {
      name: 'Pool availability',
      nameShort: 'Pool availability',
      type: 'raw',
      description: 'The percentage of pools available.',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum by ' + aggregationLabels + ' (bigip_pool_status_availability_state{%(queriesSelector)s}) / clamp_min(count by ' + aggregationLabels + ' (bigip_pool_status_availability_state{%(queriesSelector)s}),1)',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },

    virtualServerAvailability: {
      name: 'Virtual server availability',
      nameShort: 'Virtual server availability',
      type: 'raw',
      description: 'The percentage of virtual servers available.',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum by ' + aggregationLabels + ' (bigip_vs_status_availability_state{%(queriesSelector)s}) / clamp_min(count by ' + aggregationLabels + ' (bigip_vs_status_availability_state{%(queriesSelector)s}),1)',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },

    // TopK metrics for cluster overview
    topActiveServersideNodes: {
      name: 'Top active server-side nodes',
      nameShort: 'Top active nodes',
      type: 'raw',
      description: 'Nodes with the highest number of active server-side connections.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'topk($k, bigip_node_serverside_cur_conns{%(queriesSelector)s, partition=~"$bigip_partition"})',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },

    topOutboundTrafficNodes: {
      name: 'Top outbound traffic nodes',
      nameShort: 'Top outbound nodes',
      type: 'raw',
      description: 'Nodes with the highest outbound traffic.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'topk($k, increase(bigip_node_serverside_bytes_out{%(queriesSelector)s, partition=~"$bigip_partition"}[$__interval:] offset -$__interval))',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },

    topActiveMembersInPools: {
      name: 'Top active members in pools',
      nameShort: 'Top pool members',
      type: 'raw',
      description: 'Pools with the highest number of active members.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'topk($k, bigip_pool_active_member_cnt{%(queriesSelector)s, partition=~"$bigip_partition"})',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    topRequestedPools: {
      name: 'Top requested pools',
      nameShort: 'Top pools',
      type: 'raw',
      description: 'Pools with the highest number of requests.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'topk($k, increase(bigip_pool_tot_requests{%(queriesSelector)s, partition=~"$bigip_partition"}[$__interval:] offset -$__interval))',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    topQueueDepthPools: {
      name: 'Top queue depth',
      nameShort: 'Top queue depth',
      type: 'raw',
      description: 'Pools with the largest connection queues.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'topk($k, bigip_pool_connq_depth{%(queriesSelector)s, partition=~"$bigip_partition"})',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    topUtilizedVirtualServers: {
      name: 'Top utilized virtual servers',
      nameShort: 'Top VS',
      type: 'raw',
      description: 'Virtual servers with the highest traffic (inbound and outbound).',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'topk($k, increase(bigip_vs_clientside_bytes_in{%(queriesSelector)s, partition=~"$bigip_partition"}[$__interval:] offset -$__interval)) + topk($k, increase(bigip_vs_clientside_bytes_out{%(queriesSelector)s, partition=~"$bigip_partition"}[$__interval:] offset -$__interval))',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    topLatencyVirtualServers: {
      name: 'Top latency virtual servers',
      nameShort: 'Top latency VS',
      type: 'raw',
      description: 'Virtual servers with the highest response times.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'topk($k, bigip_vs_cs_mean_conn_dur{%(queriesSelector)s, partition=~"$bigip_partition"})',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },
  },
}
