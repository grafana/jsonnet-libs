local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,
      local table = g.panel.table,
      local fieldOverride = g.panel.table.fieldOverride,
      local instanceLabel = this.config.instanceLabels[0],
      fleetOverviewTable:
        commonlib.panels.generic.table.base.new(
          'Fleet overview',
          targets=
          [
            t.osInfo
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('OS Info'),
            t.uptime
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('Uptime'),
            t.cpuCount
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('Cores'),
            t.cpuUsage
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('CPU usage'),
            t.memoryTotalBytes
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('Memory total'),
            t.memoryUsagePercent
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('Memory usage'),
            t.diskTotalC
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('Disk C: total'),
            t.diskUsageCPercent
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('Disk C: used'),
            t.alertsCritical
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('CRITICAL'),
            t.alertsWarning
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)
            + g.query.prometheus.withRefId('WARNING'),
          ],
          description="All Windows instances' perfomance at a glance."
        )
        + g.panel.table.options.withFooter(
          value={
            reducer: ['sum'],
            show: true,
            fields: [
              'Value #Cores',
              'Value #Load 1',
              'Value #Memory total',
              'Value #Disk C: total',
            ],
          }
        )
        + commonlib.panels.system.table.uptime.stylizeByName('Uptime')
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byRegexp.new('Product|^Hostname$')
          + fieldOverride.byRegexp.withProperty('custom.filterable', true),
          fieldOverride.byName.new('Instance')
          + fieldOverride.byName.withProperty('custom.filterable', true)
          + fieldOverride.byName.withProperty('links', [
            {
              targetBlank: false,
              title: 'Drill down to ${__field.name} ${__value.text}',
              url: 'd/%s?var-%s=${__data.fields.%s}&${__url_time_range}' % [this.grafana.dashboards.overview.uid, instanceLabel, instanceLabel],
            },
          ]),
          fieldOverride.byRegexp.new(std.join('|', std.map(utils.toSentenceCase, this.config.groupLabels)))
          + fieldOverride.byRegexp.withProperty('custom.filterable', true)
          + fieldOverride.byRegexp.withProperty('links', [
            {
              targetBlank: false,
              title: 'Filter by ${__field.name}',
              url: 'd/%s?var-${__field.name}=${__value.text}&${__url_time_range}' % [this.grafana.dashboards.fleet.uid],
            },
          ]),
          fieldOverride.byName.new('Cores')
          + fieldOverride.byName.withProperty('custom.width', '120'),
          fieldOverride.byName.new('CPU usage')
          + fieldOverride.byName.withProperty('custom.width', '120')
          + fieldOverride.byName.withProperty('custom.displayMode', 'basic')
          + fieldOverride.byName.withPropertiesFromOptions(
            commonlib.panels.cpu.timeSeries.utilization.stylize()
          ),
          fieldOverride.byName.new('Memory total')
          + fieldOverride.byName.withProperty('custom.width', '120')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('bytes')
          ),
          fieldOverride.byName.new('Memory usage')
          + fieldOverride.byName.withProperty('custom.width', '120')
          + fieldOverride.byName.withProperty('custom.displayMode', 'basic')
          + fieldOverride.byName.withPropertiesFromOptions(
            commonlib.panels.cpu.timeSeries.utilization.stylize()
          ),
          fieldOverride.byName.new('Disk C: total')
          + fieldOverride.byName.withProperty('custom.width', '120')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('bytes')
          ),
          fieldOverride.byName.new('Disk C: used')
          + fieldOverride.byName.withProperty('custom.width', '120')
          + fieldOverride.byName.withProperty('custom.displayMode', 'basic')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
          )
          + fieldOverride.byName.withPropertiesFromOptions(
            commonlib.panels.cpu.timeSeries.utilization.stylize()
          ),
        ])
        + table.queryOptions.withTransformationsMixin(
          [
            {
              id: 'joinByField',
              options: {
                byField: instanceLabel,
                mode: 'outer',
              },
            },
            {
              id: 'filterFieldsByName',
              options: {
                include: {
                  //' 1' - would only match first occurence of group label, so no duplicates
                  pattern: std.join(' 1|', this.config.groupLabels) + ' 1|' + instanceLabel + '|product|^hostname$|Value.+',
                },
              },
            },
            {
              id: 'organize',
              options: {
                excludeByName: {
                  'Value #OS Info': true,
                },
                indexByName: {},
                renameByName:
                  {
                    product: 'Product',
                    [instanceLabel]: utils.toSentenceCase(instanceLabel),
                    hostname: 'Hostname',
                  }
                  +
                  // group labels are named as 'job 1' and so on.
                  {
                    [label + ' 1']: utils.toSentenceCase(label)
                    for label in this.config.groupLabels
                  },

              },
            },

            {
              id: 'renameByRegex',
              options: {
                regex: 'Value #(.*)',
                renamePattern: '$1',
              },
            },
          ]
        ),
      uptime: commonlib.panels.system.stat.uptime.new(targets=[t.uptime]),
      systemContextSwitchesAndInterrupts:
        commonlib.panels.generic.timeSeries.base.new(
          'Context switches/Interrupts',
          targets=[
            t.systemContextSwitches,
            t.systemInterrupts,
          ],
          description=|||
            Context switches occur when the operating system switches from running one process to another. Interrupts are signals sent to the CPU by external devices to request its attention.

            A high number of context switches or interrupts can indicate that the system is overloaded or that there are problems with specific devices or processes.
          |||
        ),
      systemExceptions:
        commonlib.panels.generic.timeSeries.base.new(
          'System calls and exceptions',
          targets=[
            t.windowsSystemExceptions,
            t.windowsSystemCalls,
          ],
        ),
      systemThreads:
        commonlib.panels.generic.timeSeries.base.new(
          'System threads',
          targets=[
            t.windowsSystemThreads,
          ],
        ),
      timeNtpStatus:
        commonlib.panels.system.statusHistory.ntp.new(
          'NTP status',
          targets=[t.timeNtpStatus],
          description='Status of time synchronization.'
        )
        + g.panel.timeSeries.standardOptions.withNoValue('No data. Please check that "time" collector is enabled.'),
      timeNtpDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'NTP delay',
          targets=[
            t.timeNtpDelay,
            t.timeOffset,
          ],
          description=|||
            NTP trip delay: Total roundtrip delay experienced by the NTP client in receiving a response from the server for the most recent request,
            in seconds. This is the time elapsed on the NTP client between transmitting a request to the NTP server and receiving a valid response from the server.

            Time offset: Absolute time offset between the system clock and the chosen time source, in seconds.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('seconds')
        + g.panel.timeSeries.standardOptions.withNoValue('No data. Please check that "time" collector is enabled.'),
      cpuCount: commonlib.panels.cpu.stat.count.new(targets=[t.cpuCount]),
      cpuUsageTs: commonlib.panels.cpu.timeSeries.utilization.new(targets=[t.cpuUsage]),
      cpuUsageTopk: commonlib.panels.generic.timeSeries.topkPercentage.new(
        title='CPU usage',
        target=t.cpuUsage,
        topk=25,
        instanceLabels=this.config.instanceLabels,
        drillDownDashboardUid=this.grafana.dashboards.overview.uid,
      ),
      cpuUsageStat: commonlib.panels.cpu.stat.usage.new(targets=[t.cpuUsage]),
      cpuUsageByMode: commonlib.panels.cpu.timeSeries.utilizationByMode.new(
        targets=[t.cpuUsageByMode],
        description=|||
          CPU usage by different modes.
        |||
      ),
      cpuQueue: commonlib.panels.generic.timeSeries.base.new(
        'CPU average queue size',
        targets=[t.cpuQueue],
        description=|||
          The CPU average queue size in Windows, often referred to as the "Processor Queue Length" or "CPU Queue Length," is a metric that measures the number of threads or tasks waiting to be processed by the central processing unit (CPU) at a given moment.
          It is an essential performance indicator that reflects the workload and responsiveness of the CPU.
          When the CPU queue length is high, it indicates that there are more tasks in line for processing than the CPU can handle immediately.

          This can lead to system slowdowns, decreased responsiveness, and potential performance issues. High CPU queue lengths are often associated with CPU saturation, where the CPU is struggling to keep up with the demands placed on it.
        |||
      ),
      memoryTotalBytes: commonlib.panels.memory.stat.total.new(targets=[t.memoryTotalBytes]),
      memoryPageTotalBytes:
        commonlib.panels.memory.stat.total.new(
          'Pagefile size',
          targets=[t.memoryPageTotalBytes],
          description=|||
            A page file (also known as a "paging file") is an optional, hidden system file on a hard disk.
            Page files enable the system to remove infrequently accessed modified pages from physical memory to let the system use physical memory more efficiently for more frequently accessed pages.

            https://learn.microsoft.com/en-us/troubleshoot/windows-client/performance/introduction-to-the-page-file
          |||
        ),
      memoryUsageStatPercent: commonlib.panels.memory.stat.usage.new(targets=[t.memoryUsagePercent]),
      memotyUsageTopKPercent: commonlib.panels.generic.timeSeries.topkPercentage.new(
        title='Memory usage',
        target=t.memoryUsagePercent,
        topk=25,
        instanceLabels=this.config.instanceLabels,
        drillDownDashboardUid=this.grafana.dashboards.overview.uid,
      ),
      memoryUsageTsBytes: commonlib.panels.memory.timeSeries.usageBytes.new(targets=[t.memoryUsedBytes, t.memoryTotalBytes]),
      diskTotalC:
        commonlib.panels.disk.stat.total.new(
          'Disk C: size',
          targets=[t.diskTotalC],
          description=|||
            Total storage capacity on the primary hard drive (usually the system drive) of a computer running a Windows operating system.
          |||
        ),
      diskUsage: commonlib.panels.disk.table.usage.new(
        totalTarget=t.diskTotal
                    + g.query.prometheus.withFormat('table')
                    + g.query.prometheus.withInstant(true),
        freeTarget=t.diskFree
                   + g.query.prometheus.withFormat('table')
                   + g.query.prometheus.withInstant(true),
        groupLabel='volume'
      ),
      diskFreeTs:
        commonlib.panels.disk.timeSeries.available.new(
          'Filesystem space availabe',
          targets=[
            t.diskFree,
          ],
          description='Filesystem space utilisation in bytes.'
        ),
      diskUsagePercentTopK: commonlib.panels.generic.timeSeries.topkPercentage.new(
        title='Disk space usage',
        target=t.diskUsagePercent,
        topk=25,
        instanceLabels=this.config.instanceLabels + ['volume'],
        drillDownDashboardUid=this.grafana.dashboards.overview.uid,
      ),
      diskIOBytesPerSec: commonlib.panels.disk.timeSeries.ioBytesPerSec.new(
        targets=[t.diskIOreadBytesPerSec, t.diskIOwriteBytesPerSec, t.diskIOutilization]
      ),
      diskIOutilPercentTopK:
        commonlib.panels.generic.timeSeries.topkPercentage.new(
          title='Disk IO',
          target=t.diskIOutilization,
          topk=25,
          instanceLabels=this.config.instanceLabels + ['volume'],
          drillDownDashboardUid=this.grafana.dashboards.overview.uid,
        ),
      diskIOps:
        commonlib.panels.disk.timeSeries.iops.new(
          targets=[
            t.diskIOReads,
            t.diskIOWrites,
          ]
        ),

      diskQueue:
        commonlib.panels.disk.timeSeries.ioQueue.new(
          'Disk average queue',
          targets=
          [
            t.diskReadQueue,
            t.diskWriteQueue,
          ]
        ),
      diskIOWaitTime: commonlib.panels.disk.timeSeries.ioWaitTime.new(
        targets=[
          t.diskIOWaitReadTime,
          t.diskIOWaitWriteTime,
        ]
      )
      ,
      osInfo: commonlib.panels.generic.stat.info.new(
        'OS family',
        targets=[t.osInfo],
        description='OS family includes various versions and editions of the Windows operating system.'
      )
              { options+: { reduceOptions+: { fields: '/^product$/' } } },
      osVersion:
        commonlib.panels.generic.stat.info.new('OS version',
                                               targets=[t.osInfo],
                                               description='Version of Windows operating system.')
        { options+: { reduceOptions+: { fields: '/^version$/' } } },
      osTimezone:
        commonlib.panels.generic.stat.info.new(
          'Timezone', targets=[t.osTimezone], description='Current system timezone.'
        )
        { options+: { reduceOptions+: { fields: '/^timezone$/' } } },
      hostname:
        commonlib.panels.generic.stat.info.new(
          'Hostname',
          targets=[t.osInfo],
          description="System's hostname."
        )
        { options+: { reduceOptions+: { fields: '/^hostname$/' } } },
      networkErrorsAndDroppedPerSec:
        commonlib.panels.network.timeSeries.errors.new(
          'Network errors and dropped packets',
          targets=
          [
            t.networkOutErrorsPerSec,
            t.networkInErrorsPerSec,
            t.networkInUknownPerSec,
            t.networkOutDroppedPerSec,
            t.networkInDroppedPerSec,
          ],
          description=|||
            **Network errors**:

            Network errors refer to issues that occur during the transmission of data across a network. 

            These errors can result from various factors, including physical issues, jitter, collisions, noise and interference.

            Monitoring network errors is essential for diagnosing and resolving issues, as they can indicate problems with network hardware or environmental factors affecting network quality.

            **Dropped packets**:

            Dropped packets occur when data packets traveling through a network are intentionally discarded or lost due to congestion, resource limitations, or network configuration issues. 

            Common causes include network congestion, buffer overflows, QoS settings, and network errors, as corrupted or incomplete packets may be discarded by receiving devices.

            Dropped packets can impact network performance and lead to issues such as degraded voice or video quality in real-time applications.
          |||
        )
        + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),
      networkErrorsAndDroppedPerSecTopK:
        commonlib.panels.network.timeSeries.errors.new(
          'Network errors and dropped packets',
          targets=std.map(
            function(t) t
                        {
              expr: 'topk(25, ' + t.expr + ')>0.5',
              legendFormat: '{{' + this.config.instanceLabels[0] + '}}: ' + std.get(t, 'legendFormat', '{{ nic }}'),
            },
            [
              t.networkOutErrorsPerSec,
              t.networkInErrorsPerSec,
              t.networkInUknownPerSec,
              t.networkOutDroppedPerSec,
              t.networkInDroppedPerSec,
            ]
          ),
          description=|||
            Top 25.

            **Network errors**:

            Network errors refer to issues that occur during the transmission of data across a network. 

            These errors can result from various factors, including physical issues, jitter, collisions, noise and interference.

            Monitoring network errors is essential for diagnosing and resolving issues, as they can indicate problems with network hardware or environmental factors affecting network quality.

            **Dropped packets**:

            Dropped packets occur when data packets traveling through a network are intentionally discarded or lost due to congestion, resource limitations, or network configuration issues. 

            Common causes include network congestion, buffer overflows, QoS settings, and network errors, as corrupted or incomplete packets may be discarded by receiving devices.

            Dropped packets can impact network performance and lead to issues such as degraded voice or video quality in real-time applications.
          |||
        )
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withPointSize(5),

      networkErrorsPerSec: commonlib.panels.network.timeSeries.errors.new('Network errors',
                                                                          targets=[t.networkInErrorsPerSec, t.networkOutErrorsPerSec, t.networkInUknownPerSec])
                           + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),
      networkDroppedPerSec: commonlib.panels.network.timeSeries.dropped.new(
                              targets=[t.networkInDroppedPerSec, t.networkOutDroppedPerSec]
                            )
                            + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),
      networkUsagePerSec: commonlib.panels.network.timeSeries.traffic.new(
                            targets=[t.networkInBitPerSec, t.networkOutBitPerSec]
                          )
                          + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
      networkPacketsPerSec: commonlib.panels.network.timeSeries.packets.new(
                              targets=[t.networkInPacketsPerSec, t.networkOutPacketsPerSec]
                            )
                            + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
    },
}
