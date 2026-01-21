function(this) {
  local aggregationLabels = '(' + std.join(',', this.groupLabels + this.instanceLabels) + ')',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: 'bigip_node_status_availability_state',
  signals: {
    availabilityState: {
      name: 'Availability status',
      nameShort: 'Status',
      type: 'gauge',
      description: 'The availability status of the node.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_node_status_availability_state{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{node}} - {{instance}}',
          valueMappings: [
            {
              type: 'value',
              options: {
                '0': {
                  color: 'red',
                  index: 1,
                  text: 'Unavailable',
                },
                '1': {
                  color: 'green',
                  index: 0,
                  text: 'Available',
                },
              },
            },
          ],
        },
      },
    },

    totalRequests: {
      name: 'Requests',
      nameShort: 'Requests',
      type: 'counter',
      description: 'The number of requests made to the node.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_node_tot_requests{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },

    currentSessions: {
      name: 'Active sessions',
      nameShort: 'Sessions',
      type: 'gauge',
      description: 'The current number of active sessions to the node.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_node_cur_sessions{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },

    serversideCurrentConns: {
      name: 'Server-side current connections',
      nameShort: 'Current conns',
      type: 'gauge',
      description: 'The current active server-side connections to the node in comparison to the maximum connection capacity.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_node_serverside_cur_conns{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },

    serversideMaxConns: {
      name: 'Server-side maximum connections',
      nameShort: 'Max conns',
      type: 'gauge',
      description: 'The maximum server-side connection capacity for the node.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_node_serverside_max_conns{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },

    serversideBytesIn: {
      name: 'Traffic inbound',
      nameShort: 'In',
      type: 'counter',
      description: 'The rate of data received from the pool by the node.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'bigip_node_serverside_bytes_in{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },

    serversideBytesOut: {
      name: 'Traffic outbound',
      nameShort: 'Out',
      type: 'counter',
      description: 'The rate of data sent from the pool by the node.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'bigip_node_serverside_bytes_out{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },

    serversidePktsIn: {
      name: 'Packets inbound',
      nameShort: 'Pkts in',
      type: 'counter',
      description: 'The number of packets received by the node from the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_node_serverside_pkts_in{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },

    serversidePktsOut: {
      name: 'Packets outbound',
      nameShort: 'Pkts out',
      type: 'counter',
      description: 'The number of packets sent by the node from the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_node_serverside_pkts_out{%(queriesSelector)s, node=~"$bigip_node", partition=~"$bigip_partition"}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{node}} - {{instance}}',
        },
      },
    },
  },
}
