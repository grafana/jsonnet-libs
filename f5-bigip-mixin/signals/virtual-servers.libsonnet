function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {

      // Virtual server status and state
      statusAvailabilityState: {
        name: 'Virtual server availability status',
        type: 'gauge',
        description: 'The availability status of the virtual server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_status_availability_state{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      // Clientside metrics
      clientsideCurrentConnections: {
        name: 'Clientside current connections',
        type: 'gauge',
        description: 'The number of current clientside connections on the virtual server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_clientside_cur_conns{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      clientsideMaxConnections: {
        name: 'Clientside max connections',
        type: 'gauge',
        description: 'The maximum number of clientside connections on the virtual server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_clientside_max_conns{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      clientsideBytesIn: {
        name: 'Clientside bytes in',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of bytes received on the clientside.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'bigip_vs_clientside_bytes_in{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      clientsideBytesOut: {
        name: 'Clientside bytes out',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of bytes sent on the clientside.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'bigip_vs_clientside_bytes_out{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      clientsideEvictedConnections: {
        name: 'Clientside evicted connections',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of clientside connections evicted.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_clientside_evicted_conns{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      clientsidePacketsIn: {
        name: 'Clientside packets in',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of packets received on the clientside.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_clientside_pkts_in{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      clientsidePacketsOut: {
        name: 'Clientside packets out',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of packets sent on the clientside.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_clientside_pkts_out{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      // Connection duration
      meanConnectionDuration: {
        name: 'Mean connection duration',
        type: 'gauge',
        description: 'The mean connection duration on the virtual server.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'bigip_vs_cs_mean_conn_dur{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      // Ephemeral metrics
      ephemeralCurrentConnections: {
        name: 'Ephemeral current connections',
        type: 'gauge',
        description: 'The number of current ephemeral connections on the virtual server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_ephemeral_cur_conns{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      ephemeralMaxConnections: {
        name: 'Ephemeral max connections',
        type: 'gauge',
        description: 'The maximum number of ephemeral connections on the virtual server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_ephemeral_max_conns{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      ephemeralBytesIn: {
        name: 'Ephemeral bytes in',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of ephemeral bytes received.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'bigip_vs_ephemeral_bytes_in{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      ephemeralBytesOut: {
        name: 'Ephemeral bytes out',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of ephemeral bytes sent.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'bigip_vs_ephemeral_bytes_out{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      ephemeralEvictedConnections: {
        name: 'Ephemeral evicted connections',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of ephemeral connections evicted.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_ephemeral_evicted_conns{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      ephemeralPacketsIn: {
        name: 'Ephemeral packets in',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of ephemeral packets received.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_ephemeral_pkts_in{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      ephemeralPacketsOut: {
        name: 'Ephemeral packets out',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of ephemeral packets sent.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_ephemeral_pkts_out{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      // Total requests
      totalRequests: {
        name: 'Total requests',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of requests made to the virtual server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'bigip_vs_tot_requests{%(queriesSelector)s, virtual_server=~"$bigip_virtual_server", partition=~"$bigip_partition"}',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      // Top metrics (using topk)
      topUtilizedVirtualServers: {
        name: 'Top utilized virtual servers',
        type: 'raw',
        description: 'Virtual servers with the highest number of current clientside connections.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk($k, bigip_vs_clientside_cur_conns{%(queriesSelector)s, partition=~"$bigip_partition"})',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },

      topLatencyVirtualServers: {
        name: 'Top latency virtual servers',
        type: 'raw',
        description: 'Virtual servers with the highest mean connection duration.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'topk($k, bigip_vs_cs_mean_conn_dur{%(queriesSelector)s, partition=~"$bigip_partition"})',
            legendCustomTemplate: '{{virtual_server}} - {{instance}}',
          },
        },
      },
    },
  }
