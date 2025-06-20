local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    rangeFunction: 'irate',
    aggKeepLabels: ['nic'],
    discoveryMetric: {
      prometheus: 'windows_net_bytes_received_total',
    },
    signals: {
      networkBytesReceived: {
        name: 'Network bytes received',
        nameShort: 'Received',
        type: 'counter',
        description: 'Network bytes received per second',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'windows_net_bytes_received_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }} received',
            exprWrappers: [['', '*8']],
          },
        },
      },
      networkBytesTransmitted: {
        name: 'Network bytes transmitted',
        nameShort: 'Transmitted',
        type: 'counter',
        description: 'Network bytes transmitted per second',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'windows_net_bytes_sent_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }} transmitted',
            exprWrappers: [['', '*8']],
          },
        },
      },
      networkPacketsReceived: {
        name: 'Network packets received',
        nameShort: 'Packets in',
        type: 'counter',
        description: 'Network packets received per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_net_packets_received_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }} packets in',
          },
        },
      },
      networkPacketsTransmitted: {
        name: 'Network packets transmitted',
        nameShort: 'Packets out',
        type: 'counter',
        description: 'Network packets transmitted per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_net_packets_sent_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }} packets out',
          },
        },
      },
      networkErrorsReceived: {
        name: 'Network errors received',
        nameShort: 'Errors in',
        type: 'counter',
        description: 'Network errors received per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_net_packets_received_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }} errors in',
          },
        },
      },
      networkErrorsTransmitted: {
        name: 'Network errors transmitted',
        nameShort: 'Errors out',
        type: 'counter',
        description: 'Network errors transmitted per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_net_packets_outbound_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }} errors out',
          },
        },
      },
      networkDiscardsReceived: {
        name: 'Network discards received',
        nameShort: 'Discards in',
        type: 'counter',
        description: 'Network discards received per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_net_packets_received_discarded_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }} discards in',
          },
        },
      },
      networkDiscardsTransmitted: {
        name: 'Network discards transmitted',
        nameShort: 'Discards out',
        type: 'counter',
        description: 'Network discards transmitted per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_net_packets_outbound_discarded_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }} discards out',
          },
        },
      },
      networkPacketsReceivedUnknown: {
        name: 'Network unknown packets received',
        nameShort: 'Unknown in',
        type: 'counter',
        description: 'Network unknown packets received per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_net_packets_received_unknown_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }} unknown in',
          },
        },
      },
      networkInterfaceStatus: {
        name: 'Network interface status',
        nameShort: 'Status',
        type: 'gauge',
        description: 'Network interface status (1=up, 0=down)',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_net_interface_status{%(queriesSelector)s}',
            legendCustomTemplate: '{{ nic }}',
            valueMappings: [
              {
                type: 'value',
                options: {
                  '1': {
                    text: 'Up',
                    color: 'light-green',
                    index: 1,
                  },
                  '0': {
                    text: 'Down',
                    color: 'light-red',
                    index: 0,
                  },
                }
              },
            ],
          },
        },
      },
    },
  } 