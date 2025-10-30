local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    signals: {
      disk_total_used_size_mb: {
        name: 'Disk total used size',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Total disk space used in MB.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_disk_total_used_size_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      disk_total_size_mb: {
        name: 'Disk total size',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Total disk space in MB.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_disk_total_size_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      disk_usage_percent: {
        name: 'Disk usage percent',
        type: 'raw',
        description: 'Disk space usage as a percentage.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum by (job, sid, host) (hanadb_disk_total_used_size_mb{%(queriesSelector)s}) / sum by (job, sid, host) (hanadb_disk_total_size_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      disk_io_throughput_kb_second: {
        name: 'Disk I/O throughput',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Disk I/O throughput in KB/s.',
        unit: 'KBs',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_disk_io_throughput_kb_second{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      disk_io_throughput_kb_second_by_disk: {
        name: 'Disk I/O throughput by disk',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Disk I/O throughput by disk device in KB/s.',
        unit: 'KBs',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host, disk) (hanadb_disk_io_throughput_kb_second{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - {{disk}}',
          },
        },
      },
    },
  }
