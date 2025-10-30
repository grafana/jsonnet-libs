function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {

      // Pool status and state
      statusAvailabilityState: {
        name: 'Pool availability status',
        type: 'gauge',
        description: 'The availability status of the pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_pool_status_availability_state{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      // Member metrics
      activeMemberCount: {
        name: 'Active member count',
        type: 'gauge',
        description: 'The number of active members in the pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_pool_active_member_cnt{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      minimumActiveMbers: {
        name: 'Minimum active members',
        type: 'gauge',
        description: 'The minimum number of active members in the pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_pool_min_active_members{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      // Connection queue metrics
      connectionQueueDepth: {
        name: 'Connection queue depth',
        type: 'gauge',
        description: 'The depth of the connection queue.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_pool_connq_depth{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      connectionQueueServiced: {
        name: 'Connection queue serviced',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of connections serviced from the queue.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_pool_connq_serviced{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      // Connection metrics
      serversideCurrentConnections: {
        name: 'Serverside current connections',
        type: 'gauge',
        description: 'The number of current serverside connections on the pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_pool_serverside_cur_conns{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      serversideMaxConnections: {
        name: 'Serverside max connections',
        type: 'gauge',
        description: 'The maximum number of serverside connections on the pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_pool_serverside_max_conns{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      // Counter metrics (with increase)
      totalRequests: {
        name: 'Total requests',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of requests made to the pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_pool_tot_requests{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
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
            expr: 'bigip_pool_serverside_bytes_in{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
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
            expr: 'bigip_pool_serverside_bytes_out{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
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
            expr: 'bigip_pool_serverside_pkts_out{%(queriesSelector)s, pool=~"$bigip_pool", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      // Top metrics (using topk)
      topActiveMembersInPools: {
        name: 'Top active members in pools',
        type: 'raw',
        description: 'Pools with the highest number of active members.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk($k, bigip_pool_active_member_cnt{%(queriesSelector)s, partition=~"$bigip_partition"})',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      topRequestedPools: {
        name: 'Top requested pools',
        type: 'raw',
        description: 'Pools with the highest number of requests.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk($k, increase(bigip_pool_tot_requests{%(queriesSelector)s, partition=~"$bigip_partition"}[$__interval:]))',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },

      topQueueDepth: {
        name: 'Top queue depth',
        type: 'raw',
        description: 'Pools with the highest connection queue depth.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk($k, bigip_pool_connq_depth{%(queriesSelector)s, partition=~"$bigip_partition"})',
            legendCustomTemplate: '{{pool}} - {{instance}}',
          },
        },
      },
    },
  }
