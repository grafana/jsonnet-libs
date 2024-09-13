local commonlib = import './common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector + ', ' + this.containerSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + s.legendLabels,
    legendLabels: ['name'],
    // agg by group, instance or none:
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      cadvisor: 'container_last_seen',
    },
    signals: {
      cpuUsage: {
        name: 'CPU usage',
        description: 'CPU time consumed in seconds by container.',
        type: 'counter',
        unit: 'percent',
        sources: {
          cadvisor: {
            expr: 'container_cpu_usage_seconds_total{%(queriesSelector)s}',
            exprWrappers: [
              ['100 *', ''],
            ],
            legendCustomTemplate: commonlib.utils.labelsToPanelLegend(s.legendLabels),
          },
        },
      },
      memoryUsage: {
        name: 'Memory usage',
        description: 'Current memory usage in bytes, including all memory regardless of when it was accessed by container.',
        type: 'gauge',
        unit: 'decbytes',
        sources: {
          cadvisor: {
            expr: 'container_memory_usage_bytes{%(queriesSelector)s}',
            legendCustomTemplate: commonlib.utils.labelsToPanelLegend(s.legendLabels),
          },
        },
      },
      networkReceive: {
        name: 'received',
        description: 'Cumulative count of bytes received.',
        type: 'counter',
        unit: 'bps',
        sources: {
          cadvisor: {
            expr: 'container_network_receive_bytes_total{%(queriesSelector)s}',
            exprWrappers: [
              ['8 *', ''],
            ],
            aggKeepLabels: ['interface'],
            legendCustomTemplate: '%s receive' % commonlib.utils.labelsToPanelLegend(s.legendLabels + ['interface']),
          },
        },
      },
      networkTransmit: {
        name: 'transmitted',
        description: 'Cumulative count of bytes transmitted.',
        type: 'counter',
        unit: 'bps',
        sources: {
          cadvisor: {
            expr: 'container_network_transmit_bytes_total{%(queriesSelector)s}',
            exprWrappers: [
              ['8 *', ''],
            ],
            aggKeepLabels: ['interface'],
            legendCustomTemplate: '%s transmit' % commonlib.utils.labelsToPanelLegend(s.legendLabels + ['interface']),
          },
        },
      },

      networkDropsReceive: {
        name: 'drops received',
        description: 'Number of packets received and dropped.',
        type: 'counter',
        unit: 'packets',
        sources: {
          cadvisor: {
            expr: 'container_network_receive_packets_dropped_total{%(queriesSelector)s}',
            aggKeepLabels: ['interface'],
            legendCustomTemplate: '%s rx drops' % commonlib.utils.labelsToPanelLegend(s.legendLabels + ['interface']),
          },
        },
      },
      networkDropsTransmit: {
        name: 'drops transmitted',
        description: 'Number of packets dropped while transmitting.',
        type: 'counter',
        unit: 'packets',
        sources: {
          cadvisor: {
            expr: 'container_network_transmit_packets_dropped_total{%(queriesSelector)s}',
            aggKeepLabels: ['interface'],
            legendCustomTemplate: '%s tx drops' % commonlib.utils.labelsToPanelLegend(s.legendLabels + ['interface']),
          },
        },
      },
      networkErrorsReceive: {
        name: 'errors received',
        description: 'Number of packets received with errors.',
        type: 'counter',
        unit: 'packets',
        sources: {
          cadvisor: {
            expr: 'container_network_receive_errors_total{%(queriesSelector)s}',
            aggKeepLabels: ['interface'],
            legendCustomTemplate: '%s rx errors' % commonlib.utils.labelsToPanelLegend(s.legendLabels + ['interface']),
          },
        },
      },
      networkErrorsTransmit: {
        name: 'errors transmitted',
        description: 'Number of packets transmitted with errors.',
        type: 'counter',
        unit: 'packets',
        sources: {
          cadvisor: {
            expr: 'container_network_transmit_errors_total{%(queriesSelector)s}',
            aggKeepLabels: ['interface'],
            legendCustomTemplate: '%s tx errors' % commonlib.utils.labelsToPanelLegend(s.legendLabels + ['interface']),
          },
        },
      },

      // disk
      diskUsageBytes: {
        name: 'Disk space usage',
        description: 'Disk space usage in bytes.',
        type: 'gauge',
        unit: 'decbytes',
        sources: {
          cadvisor: {
            expr: 'container_fs_usage_bytes{%(queriesSelector)s}',
            aggKeepLabels: ['device'],
            legendCustomTemplate: '%s' % commonlib.utils.labelsToPanelLegend(s.legendLabels + ['device']),
          },
        },
      },
      diskReads: {
        name: 'Disk reads',
        description: 'The number of read requests per second for the device/volume.',
        type: 'counter',
        unit: 'ops',
        sources: {
          cadvisor: {
            expr: 'container_fs_reads_total{%(queriesSelector)s}',
            aggKeepLabels: ['device'],
            legendCustomTemplate: '%s' % commonlib.utils.labelsToPanelLegend(s.legendLabels + ['device']),
          },
        },
      },
      diskWrites: {
        name: 'Disk writes',
        description: 'The number of write requests per second for the device/volume.',
        type: 'counter',
        unit: 'ops',
        sources: {
          cadvisor: {
            expr: 'container_fs_writes_total{%(queriesSelector)s}',
            aggKeepLabels: ['device'],
            legendCustomTemplate: '%s' % commonlib.utils.labelsToPanelLegend(s.legendLabels + ['device']),
          },
        },
      },
    },
  }
