local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    aggKeepLabels: ['volume'],
    rangeFunction: 'irate',
    discoveryMetric: {
      prometheus: 'windows_logical_disk_size_bytes',
    },
    signals: {
      diskTotal: {
        name: 'Disk total',
        nameShort: 'Total',
        type: 'gauge',
        description: 'Total disk space in bytes',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_size_bytes{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}',
          },
        },
      },
      diskFree: {
        name: 'Disk free',
        nameShort: 'Free',
        type: 'gauge',
        description: 'Free disk space in bytes',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_free_bytes{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}',
            legendCustomTemplate: '{{ volume }} available',
          },
        },
      },
      diskUsed: {
        name: 'Disk used',
        nameShort: 'Used',
        type: 'gauge',
        description: 'Used disk space in bytes',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_size_bytes{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}-windows_logical_disk_free_bytes{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}',
            legendCustomTemplate: '{{ volume }} used',
          },
        },
      },
      diskUsagePercent: {
        name: 'Disk usage',
        nameShort: 'Usage',
        type: 'gauge',
        description: 'Disk usage percentage',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 - windows_logical_disk_free_bytes{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}/windows_logical_disk_size_bytes{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}*100',
            legendCustomTemplate: '{{ volume }} used',
          },
        },
      },
      diskC: {
        name: 'C: drive',
        nameShort: 'C:',
        type: 'gauge',
        description: 'C: drive metrics',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_size_bytes{volume="C:", %(queriesSelector)s}',
          },
        },
      },
      diskCUsage: {
        name: 'C: drive usage',
        nameShort: 'C: Used',
        type: 'gauge',
        description: 'C: drive usage in bytes',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_size_bytes{volume="C:", %(queriesSelector)s}-windows_logical_disk_free_bytes{volume="C:", %(queriesSelector)s}',
          },
        },
      },
      diskCUsagePercent: {
        name: 'C: drive usage',
        nameShort: 'C: Used',
        type: 'gauge',
        description: 'C: drive usage percentage',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 - windows_logical_disk_free_bytes{volume="C:", %(queriesSelector)s}/windows_logical_disk_size_bytes{volume="C:", %(queriesSelector)s}*100',
          },
        },
      },
      diskIOReadBytes: {
        name: 'Disk read bytes',
        nameShort: 'Read',
        type: 'counter',
        description: 'Disk read bytes per second',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_read_bytes_total{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}',
            legendCustomTemplate: '{{ volume }} read',
          },
        },
      },
      diskIOWriteBytes: {
        name: 'Disk write bytes',
        nameShort: 'Write',
        type: 'counter',
        description: 'Disk write bytes per second',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_write_bytes_total{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}',
            legendCustomTemplate: '{{ volume }} written',
          },
        },
      },
      diskIOUtilization: {
        name: 'Disk I/O utilization',
        nameShort: 'I/O util',
        type: 'raw',
        description: 'Disk I/O utilization percentage',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '(1-clamp_max(irate(windows_logical_disk_idle_seconds_total{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}[%(interval)s]),1)) * 100',
            legendCustomTemplate: '{{ volume }} io util',
          },
        },
      },
      diskReadQueue: {
        name: 'Disk read queue',
        nameShort: 'Read queue',
        type: 'counter',
        description: 'Average read requests queued',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_avg_read_requests_queued{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}',
            legendCustomTemplate: '{{ volume }} read queue',
          },
        },
      },
      diskWriteQueue: {
        name: 'Disk write queue',
        nameShort: 'Write queue',
        type: 'counter',
        description: 'Average write requests queued',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_avg_write_requests_queued{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}',
            legendCustomTemplate: '{{ volume }} write queue',
          },
        },
      },
      diskReadTime: {
        name: 'Disk read time',
        nameShort: 'Read time',
        type: 'raw',
        description: 'Average disk read time',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'irate(windows_logical_disk_read_seconds_total{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}[%(interval)s]) / irate(windows_logical_disk_reads_total{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}[%(interval)s])',
            legendCustomTemplate: '{{ volume }} avg read time',
          },
        },
      },
      diskWriteTime: {
        name: 'Disk write time',
        nameShort: 'Write time',
        type: 'raw',
        description: 'Average disk write time',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'irate(windows_logical_disk_write_seconds_total{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}[%(interval)s]) / irate(windows_logical_disk_writes_total{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}[%(interval)s])',
            legendCustomTemplate: '{{ volume }} avg write time',
          },
        },
      },
      diskReads: {
        name: 'Disk reads',
        nameShort: 'Reads',
        type: 'counter',
        description: 'Disk reads per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_reads_total{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}',
            legendCustomTemplate: '{{ volume }} reads',
          },
        },
      },
      diskWrites: {
        name: 'Disk writes',
        nameShort: 'Writes',
        type: 'counter',
        description: 'Disk writes per second',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_logical_disk_writes_total{volume!~"' + this.ignoreVolumes + '", %(queriesSelector)s}',
            legendCustomTemplate: '{{ volume }} writes',
          },
        },
      },
      diskDriveStatus: {
        name: 'Disk drive status',
        nameShort: 'Disk status',
        type: 'gauge',
        description: 'Physical disk drive status',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_disk_drive_status{%(queriesSelector)s}',
            legendCustomTemplate: '{{ name }}',
            valueMappings: [
              {
                type: 'value',
                options: {
                  '1': {
                    text: 'OK',
                    color: 'light-green',
                    index: 1,
                  },
                  '0': {
                    text: 'Not OK',
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