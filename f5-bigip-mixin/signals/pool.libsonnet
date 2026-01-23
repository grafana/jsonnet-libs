function(this) {
  local aggregationLabels = '(' + std.join(',', this.groupLabels + this.instanceLabels) + ')',
  local poolSelector = 'pool=~"$bigip_pool", partition=~"$bigip_partition"',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: 'bigip_pool_status_availability_state',
  signals: {
    availabilityState: {
      name: 'Availability status',
      nameShort: 'Status',
      type: 'gauge',
      description: 'The availability status of the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_status_availability_state{%(queriesSelector)s, ' + poolSelector + '}',
          legendCustomTemplate: '{{pool}} - {{instance}}',
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
      description: 'The number of requests made to the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_tot_requests{%(queriesSelector)s, ' + poolSelector + '}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    activeMemberCount: {
      name: 'Active members',
      nameShort: 'Active members',
      type: 'gauge',
      description: 'The number of active and minimum required members within the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_active_member_cnt{%(queriesSelector)s, ' + poolSelector + '}',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    minActiveMembers: {
      name: 'Minimum active members',
      nameShort: 'Min members',
      type: 'gauge',
      description: 'The minimum required number of active members within the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_min_active_members{%(queriesSelector)s, ' + poolSelector + '}',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    serversideCurrentConns: {
      name: 'Server-side current connections',
      nameShort: 'Current conns',
      type: 'gauge',
      description: 'The current and maximum number of node connections within the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_serverside_cur_conns{%(queriesSelector)s, ' + poolSelector + '}',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    serversideMaxConns: {
      name: 'Server-side maximum connections',
      nameShort: 'Max conns',
      type: 'gauge',
      description: 'The maximum number of node connections within the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_serverside_max_conns{%(queriesSelector)s, ' + poolSelector + '}',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    connectionQueueDepth: {
      name: 'Connection queue depth',
      nameShort: 'Queue depth',
      type: 'gauge',
      description: 'The depth of connection queues within the pool, including the current depth.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_connq_depth{%(queriesSelector)s, ' + poolSelector + '}',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    connectionQueueServiced: {
      name: 'Connection queue serviced',
      nameShort: 'Queue serviced',
      type: 'counter',
      description: 'The number of connections that have been serviced within the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_connq_serviced{%(queriesSelector)s, ' + poolSelector + '}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    serversideBytesIn: {
      name: 'Traffic inbound',
      nameShort: 'In',
      type: 'counter',
      description: 'The rate of data received from virtual servers by the pool.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'bigip_pool_serverside_bytes_in{%(queriesSelector)s, ' + poolSelector + '}',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    serversideBytesOut: {
      name: 'Traffic outbound',
      nameShort: 'Out',
      type: 'counter',
      description: 'The rate of data sent from virtual servers by the pool.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'bigip_pool_serverside_bytes_out{%(queriesSelector)s, ' + poolSelector + '}',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    serversidePktsIn: {
      name: 'Packets inbound',
      nameShort: 'Pkts in',
      type: 'counter',
      description: 'The number of packets received from virtual servers by the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_serverside_pkts_in{%(queriesSelector)s, ' + poolSelector + '}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },

    serversidePktsOut: {
      name: 'Packets outbound',
      nameShort: 'Pkts out',
      type: 'counter',
      description: 'The number of packets sent from virtual servers by the pool.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_pool_serverside_pkts_out{%(queriesSelector)s, ' + poolSelector + '}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{pool}} - {{instance}}',
        },
      },
    },
  },
}
