local commonlib = import 'common-lib/common/main.libsonnet';

// Vultr exposes instance metrics already computed as gauges (rates and
// percentages), so signals are rendered as-is without rate().
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'vultr_instance_cpu_usage_percent',
    },
    signals: {
      instanceCount: {
        name: 'Instances',
        nameShort: 'Instances',
        type: 'raw',
        unit: 'short',
        description: 'Number of Vultr instances reporting metrics.',
        sources: {
          prometheus: {
            expr: 'count(vultr_instance_cpu_usage_percent{%(queriesSelector)s})',
            legendCustomTemplate: 'Instances',
          },
        },
      },

      instanceInfo: {
        name: 'Instances',
        nameShort: 'Instances',
        type: 'raw',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'vultr_instance_bandwidth_allowed_bytes{%(queriesSelector)s} * 0',
          },
        },
      },

      cpuUsage: {
        name: 'CPU usage',
        nameShort: 'CPU',
        type: 'gauge',
        unit: 'percent',
        description: 'Current CPU usage of the instance.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_cpu_usage_percent{%(queriesSelector)s}',
          },
        },
      },

      diskReadOps: {
        name: 'Disk read operations',
        nameShort: 'Read',
        type: 'gauge',
        unit: 'iops',
        description: 'Current disk read operations per second.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_disk_read_ops_per_sec{%(queriesSelector)s}',
            legendCustomTemplate: '{{label}} read',
          },
        },
      },
      diskWriteOps: {
        name: 'Disk write operations',
        nameShort: 'Write',
        type: 'gauge',
        unit: 'iops',
        description: 'Current disk write operations per second.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_disk_write_ops_per_sec{%(queriesSelector)s}',
            legendCustomTemplate: '{{label}} write',
          },
        },
      },

      networkReceive: {
        name: 'Network receive',
        nameShort: 'Receive',
        type: 'gauge',
        unit: 'Bps',
        description: 'Current network receive rate.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_network_rx_bytes_per_sec{%(queriesSelector)s}',
            aggKeepLabels: ['interface'],
            legendCustomTemplate: '{{label}} {{interface}} receive',
          },
        },
      },
      networkTransmit: {
        name: 'Network transmit',
        nameShort: 'Transmit',
        type: 'gauge',
        unit: 'Bps',
        description: 'Current network transmit rate.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_network_tx_bytes_per_sec{%(queriesSelector)s}',
            aggKeepLabels: ['interface'],
            legendCustomTemplate: '{{label}} {{interface}} transmit',
          },
        },
      },

      // The bandwidth counters reset at the start of each billing period, so they
      // are shown as raw totals rather than rates.
      bandwidthReceived: {
        name: 'Inbound bandwidth this billing period',
        nameShort: 'Inbound',
        type: 'raw',
        unit: 'decbytes',
        description: 'Total inbound bandwidth used in the current billing period.',
        sources: {
          prometheus: {
            expr: 'max by (%(agg)s) (vultr_instance_bandwidth_rx_bytes_total{%(queriesSelector)s})',
            legendCustomTemplate: '{{label}} inbound',
          },
        },
      },
      bandwidthTransmitted: {
        name: 'Outbound bandwidth this billing period',
        nameShort: 'Outbound',
        type: 'raw',
        unit: 'decbytes',
        description: 'Total outbound bandwidth used in the current billing period.',
        sources: {
          prometheus: {
            expr: 'max by (%(agg)s) (vultr_instance_bandwidth_tx_bytes_total{%(queriesSelector)s})',
            legendCustomTemplate: '{{label}} outbound',
          },
        },
      },
      bandwidthAllowed: {
        name: 'Bandwidth allowance',
        nameShort: 'Allowance',
        type: 'gauge',
        unit: 'decbytes',
        description: 'Bandwidth allowance for the current billing period.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_bandwidth_allowed_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{label}} allowance',
          },
        },
      },
      bandwidthUsage: {
        name: 'Bandwidth allowance used',
        nameShort: 'Allowance used',
        type: 'raw',
        unit: 'percent',
        aggLevel: 'group',
        description: 'Outbound bandwidth used in the current billing period as a percentage of the pooled allowance. Vultr only counts outbound bandwidth and pools allowances across all instances in the account.',
        sources: {
          prometheus: {
            expr: '100 * sum by (%(agg)s) (vultr_instance_bandwidth_tx_bytes_total{%(queriesSelector)s}) / (sum by (%(agg)s) (vultr_instance_bandwidth_allowed_bytes{%(queriesSelector)s}) > 0)',
            legendCustomTemplate: '{{job}}',
          },
        },
      },

      // GPU metrics are only reported by GPU plans.
      gpuUtilization: {
        name: 'GPU utilization',
        nameShort: 'GPU',
        type: 'gauge',
        unit: 'percent',
        description: 'Current GPU utilization. Only reported by GPU instances.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_gpu_utilization_percent{%(queriesSelector)s}',
          },
        },
      },
      gpuMemoryUsed: {
        name: 'GPU memory used',
        nameShort: 'GPU memory',
        type: 'gauge',
        unit: 'decmbytes',
        description: 'Current GPU memory used. Only reported by GPU instances.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_gpu_memory_used_mb{%(queriesSelector)s}',
          },
        },
      },
      gpuTemperature: {
        name: 'GPU temperature',
        nameShort: 'Temperature',
        type: 'gauge',
        unit: 'celsius',
        description: 'Current GPU temperature. Only reported by GPU instances.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_gpu_temperature_celsius{%(queriesSelector)s}',
          },
        },
      },
      gpuPower: {
        name: 'GPU power',
        nameShort: 'Power',
        type: 'gauge',
        unit: 'watt',
        description: 'Current GPU power consumption. Only reported by GPU instances.',
        sources: {
          prometheus: {
            expr: 'vultr_instance_gpu_power_watts{%(queriesSelector)s}',
          },
        },
      },
    },
  }
