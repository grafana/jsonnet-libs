local common = import './common.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'instance',
    aggFunction: 'max',
    discoveryMetric: common.discoveryMetric,
    signals: {
      // target_info carries the resource attributes set by the resourcedetection processor.
      hostname: {
        name: 'Host name',
        nameShort: 'Hostname',
        type: 'info',
        aggLevel: 'instance',
        description: 'Hostname reported by the host.',
        sources: common.sources('target_info{%(queriesSelector)s, host_name!=""}', { infoLabel: 'host_name' }),
      },
      // os_description ends in the kernel's uname, i.e. "Ubuntu 24.04.5 LTS (Noble Numbat) (Linux host 6.8.0 ...)":
      // keep what comes before the first " (".
      osName: {
        name: 'Operating system',
        nameShort: 'OS',
        type: 'info',
        aggLevel: 'instance',
        description: 'Distribution reported by the host.',
        sources: common.sources(
          'label_replace(target_info{%(queriesSelector)s, os_description!=""}, "os_name", "$1", "os_description", "(.+?)( [(].*)?")',
          { infoLabel: 'os_name' }
        ),
      },
      arch: {
        name: 'Architecture',
        nameShort: 'Arch',
        type: 'info',
        aggLevel: 'none',
        description: 'CPU architecture reported by the host.',
        sources: common.sources('target_info{%(queriesSelector)s, host_arch!=""}', { infoLabel: 'host_arch' }),
      },
      uptime: {
        name: 'Uptime',
        type: 'gauge',
        description: 'Time since the host last booted.',
        unit: 's',
        sources: common.sources('system_uptime{%(queriesSelector)s}'),
      },
      // Raw: timestamp() has to see the unaggregated series to return each sample's time.
      bootTime: {
        name: 'Boot time',
        nameShort: 'Boot',
        type: 'raw',
        description: 'When the host last booted, to the minute, in seconds since the Unix epoch.',
        unit: 'dateTimeAsIso',
        sources: common.sources('max by (%(agg)s) (round(timestamp(system_uptime{%(queriesSelector)s}) - system_uptime{%(queriesSelector)s}, 60))'),
      },
      // Raw: counts os_description changes with a subquery, for an annotation only.
      osChanges: {
        name: 'OS or kernel change',
        nameShort: 'OS change',
        type: 'raw',
        description: 'The reported distribution or kernel changed.',
        unit: 'short',
        sources: common.sources('changes(sum by (%(agg)s) (group by (%(agg)s, os_description) (target_info{%(queriesSelector)s, os_description!=""}))[$__interval:1m] offset -$__interval) > 1'),
      },
      cpuCount: {
        name: 'CPU cores',
        nameShort: 'Cores',
        type: 'gauge',
        description: 'Logical cores available.',
        unit: 'short',
        sources: common.sources('system_cpu_logical_count{%(queriesSelector)s}'),
      },
      cpuPhysicalCount: {
        name: 'Physical cores',
        type: 'gauge',
        description: 'Physical cores available.',
        unit: 'short',
        sources: common.sources('system_cpu_physical_count{%(queriesSelector)s}'),
      },
      processesRunning: {
        name: 'Processes running',
        nameShort: 'Running',
        type: 'gauge',
        description: 'Processes currently running.',
        unit: 'short',
        sources: common.sources('system_processes_count{%(queriesSelector)s, status="running"}'),
      },
      processesCreated: {
        name: 'Processes created',
        nameShort: 'Created',
        type: 'counter',
        aggFunction: 'sum',
        description: 'Processes created per second.',
        unit: 'short',
        sources: common.sources('system_processes_created{%(queriesSelector)s}'),
      },
    },
  }
