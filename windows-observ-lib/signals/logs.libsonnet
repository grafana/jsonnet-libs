local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    
    // logs-lib compatibility fields
    extraLogLabels: this.extraLogLabels,
    logsVolumeGroupBy: this.logsVolumeGroupBy,
    showLogsVolume: this.showLogsVolume,
    logsExtraFilters: this.logsExtraFilters,
    
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'windows_logical_disk_size_bytes',
    },
    signals: {
      serviceFailedLogs: {
        name: 'Service failed logs',
        nameShort: 'Service failed',
        type: 'log',
        description: 'Service Control Manager error logs',
        sources: {
          prometheus: {
            expr: '{%(queriesSelector)s, source="Service Control Manager", level="Error"} |= "terminated" | json',
          },
        },
      },
      criticalEventsLogs: {
        name: 'Critical system events',
        nameShort: 'Critical events',
        type: 'log',
        description: 'Critical system events from Windows logs',
        sources: {
          prometheus: {
            expr: '{%(queriesSelector)s, channel="System", level="Critical"} | json',
          },
        },
      },
    },
  } 