function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {

      diskReadCount: {
        name: 'Disk read operations',
        type: 'counter',
        description: 'Number of disk read operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_read_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      diskWriteCount: {
        name: 'Disk write operations',
        type: 'counter',
        description: 'Number of disk write operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_write_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      diskReadTime: {
        name: 'Disk read I/O time',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Time spent on read I/O operations.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_read_time_milliseconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}} - reads',
          },
        },
      },

      diskWriteTime: {
        name: 'Disk write I/O time',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Time spent on write I/O operations.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_write_time_milliseconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}} - writes',
          },
        },
      },

      cpuIrqTime: {
        name: 'CPU interrupt service time',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'CPU time spent servicing interrupts.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'hardware_system_cpu_irq_milliseconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{cl_name}}',
          },
        },
      },

      diskSpaceUsed: {
        name: 'Disk space used',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        description: 'Disk space used.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_disk_space_used_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - used',
          },
        },
      },

      diskSpaceFree: {
        name: 'Disk space free',
        type: 'gauge',
        aggLevel: 'instance',
        aggFunction: 'sum',
        description: 'Disk space free.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'hardware_disk_metrics_disk_space_free_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - free',
          },
        },
      },

      diskSpaceUtilization: {
        name: 'Disk space utilization',
        type: 'raw',
        description: 'Percentage of disk space used.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * ((sum without (disk_name) (hardware_disk_metrics_disk_space_used_bytes{%(queriesSelector)s})) / clamp_min((sum without (disk_name) (hardware_disk_metrics_disk_space_used_bytes{%(queriesSelector)s})) + (sum without (disk_name) (hardware_disk_metrics_disk_space_free_bytes{%(queriesSelector)s})), 1))',
            legendCustomTemplate: '{{cl_name}}',
          },
        },
      },
    },
  }
