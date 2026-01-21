function(this) {
  local aggregationLabels = '(' + std.join(',', this.groupLabels + this.instanceLabels) + ')',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: 'bigip_vs_status_availability_state',
  signals: {
    availabilityState: {
      name: 'Availability status',
      nameShort: 'Status',
      type: 'gauge',
      description: 'The availability status of the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_status_availability_state{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
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
      description: 'The number of requests made to the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_tot_requests{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    clientsideMeanConnDuration: {
      name: 'Average connection duration',
      nameShort: 'Avg conn duration',
      type: 'gauge',
      description: 'The average connection duration within the virtual server.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'bigip_vs_cs_mean_conn_dur{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    clientsideCurrentConns: {
      name: 'Client-side current connections',
      nameShort: 'Current conns',
      type: 'gauge',
      description: 'The evicted and current client-side connections within the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_clientside_cur_conns{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    clientsideMaxConns: {
      name: 'Client-side maximum connections',
      nameShort: 'Max conns',
      type: 'gauge',
      description: 'The maximum client-side connections within the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_clientside_max_conns{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    clientsideEvictedConns: {
      name: 'Client-side evicted connections',
      nameShort: 'Evicted conns',
      type: 'gauge',
      description: 'The evicted client-side connections within the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_clientside_evicted_conns{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    ephemeralCurrentConns: {
      name: 'Ephemeral current connections',
      nameShort: 'Ephemeral current',
      type: 'gauge',
      description: 'The ephemeral evicted and current client-side connections within the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_ephemeral_cur_conns{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    ephemeralMaxConns: {
      name: 'Ephemeral maximum connections',
      nameShort: 'Ephemeral max',
      type: 'gauge',
      description: 'The ephemeral maximum client-side connections within the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_ephemeral_max_conns{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    ephemeralEvictedConns: {
      name: 'Ephemeral evicted connections',
      nameShort: 'Ephemeral evicted',
      type: 'gauge',
      description: 'The ephemeral evicted client-side connections within the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_ephemeral_evicted_conns{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}} - evicted',
        },
      },
    },

    clientsideBytesIn: {
      name: 'Traffic inbound',
      nameShort: 'In',
      type: 'counter',
      description: 'The rate of data received from clients by the virtual server.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'bigip_vs_clientside_bytes_in{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    clientsideBytesOut: {
      name: 'Traffic outbound',
      nameShort: 'Out',
      type: 'counter',
      description: 'The rate of data sent from clients by the virtual server.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'bigip_vs_clientside_bytes_out{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    ephemeralBytesIn: {
      name: 'Ephemeral traffic inbound',
      nameShort: 'Ephemeral in',
      type: 'counter',
      description: 'The rate of ephemeral data received from clients by the virtual server.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'bigip_vs_ephemeral_bytes_in{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    ephemeralBytesOut: {
      name: 'Ephemeral traffic outbound',
      nameShort: 'Ephemeral out',
      type: 'counter',
      description: 'The rate of ephemeral data sent from clients by the virtual server.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'bigip_vs_ephemeral_bytes_out{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    clientsidePktsIn: {
      name: 'Packets inbound',
      nameShort: 'Pkts in',
      type: 'counter',
      description: 'The number of packets received by the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_clientside_pkts_in{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    clientsidePktsOut: {
      name: 'Packets outbound',
      nameShort: 'Pkts out',
      type: 'counter',
      description: 'The number of packets sent by the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_clientside_pkts_out{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    ephemeralPktsIn: {
      name: 'Ephemeral packets inbound',
      nameShort: 'Ephemeral pkts in',
      type: 'counter',
      description: 'The number of ephemeral packets received by the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_ephemeral_pkts_in{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },

    ephemeralPktsOut: {
      name: 'Ephemeral packets outbound',
      nameShort: 'Ephemeral pkts out',
      type: 'counter',
      description: 'The number of ephemeral packets sent by the virtual server.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'bigip_vs_ephemeral_pkts_out{%(queriesSelector)s, vs=~"$bigip_vs", partition=~"$bigip_partition"}',
          rangeFunction: 'increase',
          legendCustomTemplate: '{{vs}} - {{instance}}',
        },
      },
    },
  },
}
