function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {

      // Node status and state
      statusAvailabilityState: {
        name: 'Node availability status',
        type: 'gauge',
        description: 'The availability status of the node.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_node_status_availability_state{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      // Current metrics
      currentSessions: {
        name: 'Current sessions',
        type: 'gauge',
        description: 'The number of current sessions on the node.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_node_cur_sessions{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      serversideCurrentConnections: {
        name: 'Serverside current connections',
        type: 'gauge',
        description: 'The number of current serverside connections on the node.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_node_serverside_cur_conns{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      serversideMaxConnections: {
        name: 'Serverside max connections',
        type: 'gauge',
        description: 'The maximum number of serverside connections on the node.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_node_serverside_max_conns{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      // Counter metrics (with increase)
      totalRequests: {
        name: 'Total requests',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of requests made to the node.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_node_tot_requests{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      serversideBytesIn: {
        name: 'Serverside bytes in',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of bytes received on the serverside.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'bigip_node_serverside_bytes_in{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      serversideBytesOut: {
        name: 'Serverside bytes out',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of bytes sent on the serverside.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'bigip_node_serverside_bytes_out{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      serversidePacketsIn: {
        name: 'Serverside packets in',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of packets received on the serverside.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_node_serverside_pkts_in{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      serversidePacketsOut: {
        name: 'Serverside packets out',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of packets sent on the serverside.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_node_serverside_pkts_out{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      // Top metrics (using topk)
      topActiveServersideNodes: {
        name: 'Top active serverside nodes',
        type: 'raw',
        description: 'Nodes with the highest number of active serverside connections.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk($k, bigip_node_serverside_cur_conns{%(queriesSelector)s, partition=~"$bigip_partition"})',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },

      topOutboundTrafficNodes: {
        name: 'Top outbound traffic nodes',
        type: 'raw',
        description: 'Nodes with the highest outbound traffic.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'topk($k, increase(bigip_node_serverside_bytes_out{%(queriesSelector)s, partition=~"$bigip_partition"}[$__interval:]))',
            legendCustomTemplate: '{{node}} - {{instance}}',
          },
        },
      },
    },
  }
