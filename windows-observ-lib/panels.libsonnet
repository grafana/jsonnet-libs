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
          fieldOverride.byName.new(utils.toSentenceCase(instanceLabel))
          + fieldOverride.byName.withProperty('custom.filterable', true)
          + fieldOverride.byName.withProperty('links', [
            {
              targetBlank: false,
              title: 'Drill down to ${__field.name} ${__value.text}',
              url: 'd/%s?var-%s=${__data.fields.%s}&${__url_time_range}&${datasource:queryparam}' % [this.grafana.dashboards.overview.uid, instanceLabel, instanceLabel],
            },
          ]),
          fieldOverride.byRegexp.new(std.join('|', std.map(utils.toSentenceCase, this.config.groupLabels)))
          + fieldOverride.byRegexp.withProperty('custom.filterable', true)
          + fieldOverride.byRegexp.withProperty('links', [
            {
              targetBlank: false,
              title: 'Filter by ${__field.name}',
              url: 'd/%s?var-${__field.name}=${__value.text}&${__url_time_range}&${datasource:queryparam}' % [this.grafana.dashboards.fleet.uid],
            },
          ]),
          fieldOverride.byName.new('Cores')
          + fieldOverride.byName.withProperty('custom.width', 120),
          fieldOverride.byName.new('CPU usage')
          + fieldOverride.byName.withProperty('custom.width', 120)
          + fieldOverride.byName.withProperty('custom.displayMode', 'basic')
          + fieldOverride.byName.withPropertiesFromOptions(
            commonlib.panels.cpu.timeSeries.utilization.stylize()
          ),
          fieldOverride.byName.new('Memory total')
          + fieldOverride.byName.withProperty('custom.width', 120)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('bytes')
          ),
          fieldOverride.byName.new('Memory usage')
          + fieldOverride.byName.withProperty('custom.width', 120)
          + fieldOverride.byName.withProperty('custom.displayMode', 'basic')
          + fieldOverride.byName.withPropertiesFromOptions(
            commonlib.panels.cpu.timeSeries.utilization.stylize()
          ),
          fieldOverride.byName.new('Disk C: total')
          + fieldOverride.byName.withProperty('custom.width', 120)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('bytes')
          ),
          fieldOverride.byName.new('Disk C: used')
          + fieldOverride.byName.withProperty('custom.width', 120)
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
                  pattern: std.join(' 1$|', this.config.groupLabels) + ' 1$|' + instanceLabel + '|product|^hostname$|Value.+',
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
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),
      systemExceptions:
        commonlib.panels.generic.timeSeries.base.new(
          'System calls and exceptions',
          targets=[
            t.windowsSystemExceptions,
            t.windowsSystemCalls,
          ],
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),
      systemThreads:
        commonlib.panels.generic.timeSeries.base.new(
          'System threads',
          targets=[
            t.windowsSystemThreads,
          ],
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),
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
        + g.panel.timeSeries.standardOptions.withUnit('s')
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
      cpuQueue:
        commonlib.panels.generic.timeSeries.base.new(
          'CPU average queue size',
          targets=[t.cpuQueue],
          description=|||
            The CPU average queue size in Windows, often referred to as the "Processor Queue Length" or "CPU Queue Length," is a metric that measures the number of threads or tasks waiting to be processed by the central processing unit (CPU) at a given moment.
            It is an essential performance indicator that reflects the workload and responsiveness of the CPU.
            When the CPU queue length is high, it indicates that there are more tasks in line for processing than the CPU can handle immediately.

            This can lead to system slowdowns, decreased responsiveness, and potential performance issues. High CPU queue lengths are often associated with CPU saturation, where the CPU is struggling to keep up with the demands placed on it.
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),
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
      memoryUsageTopKPercent: commonlib.panels.generic.timeSeries.topkPercentage.new(
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
        { options+: { reduceOptions+: { fields: '/^instance$/' } } },
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

      alertsPanel: g.panel.alertList.new(
                     'Windows Active Directory alerts'
                   )
                   + g.panel.alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesSelectorAdvancedSyntax),
      replicationPendingOperations: commonlib.panels.generic.stat.info.new(
        'Replication pending operations',
        targets=[t.replicationPendingOperations],
        description=|||
          The number of replication operations that are pending in Active Directory.
          These operations could include a variety of tasks, such as updating directory objects, processing changes made on other domain controllers, or applying new schema updates.
        |||
      ),
      directoryServiceThreads: commonlib.panels.generic.stat.info.new(
        'Directory service threads',
        targets=[t.directoryServiceThreads],
        description=|||
          The current number of active threads in the directory service.
        |||
      ),
      replicationPendingSynchronizations: commonlib.panels.generic.stat.info.new(
        'Replication pending synchronizations',
        targets=[t.replicationPendingSynchronizations],
        description=|||
          The number of synchronization requests that are pending in Active Directory. Synchronization in AD refers to the process of ensuring that changes (like updates to user accounts, group policies, etc.) are consistently applied across all domain controllers.
        |||
      ),
      ldapBindRequests: commonlib.panels.generic.timeSeries.base.new(
                          'LDAP bind requests',
                          targets=[t.ldapBindRequests],
                          description=|||
                            The rate at which LDAP bind requests are being made.
                          |||
                        )
                        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      ldapOperations: commonlib.panels.generic.timeSeries.base.new(
                        'LDAP operations',
                        targets=[t.ldapOperations],
                        description=|||
                          The rate of LDAP read, search, and write operations.
                        |||
                      )
                      + g.panel.timeSeries.standardOptions.withUnit('ops'),

      bindOperationsOverview: commonlib.panels.generic.table.base.new(
                                'Bind operations overview',
                                targets=[t.bindOperationsOverview],
                                description=|||
                                  Distribution of different types of operations performed on the Active Directory database.
                                |||
                              )
                              + g.panel.table.standardOptions.withOverridesMixin([
                                fieldOverride.byName.new('Digest')
                                + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                + fieldOverride.byName.withProperty('custom.align', 'left')
                                + fieldOverride.byName.withPropertiesFromOptions(
                                  table.standardOptions.withUnit('ops')
                                  + table.standardOptions.color.withMode('continuous-BlPu')
                                ),
                              ])
                              + g.panel.table.standardOptions.withOverridesMixin([
                                fieldOverride.byName.new('DS_client')
                                + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                + fieldOverride.byName.withProperty('custom.align', 'left')
                                + fieldOverride.byName.withPropertiesFromOptions(
                                  table.standardOptions.withUnit('ops')
                                  + table.standardOptions.color.withMode('continuous-BlPu')
                                ),
                              ])
                              + g.panel.table.standardOptions.withOverridesMixin([
                                fieldOverride.byName.new('DS_server')
                                + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                + fieldOverride.byName.withProperty('custom.align', 'left')
                                + fieldOverride.byName.withPropertiesFromOptions(
                                  table.standardOptions.withUnit('ops')
                                  + table.standardOptions.color.withMode('continuous-BlPu')
                                ),
                              ])
                              + g.panel.table.standardOptions.withOverridesMixin([
                                fieldOverride.byName.new('External')
                                + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                + fieldOverride.byName.withProperty('custom.align', 'left')
                                + fieldOverride.byName.withPropertiesFromOptions(
                                  table.standardOptions.withUnit('ops')
                                  + table.standardOptions.color.withMode('continuous-BlPu')
                                ),
                              ])
                              + g.panel.table.standardOptions.withOverridesMixin([
                                fieldOverride.byName.new('Fast')
                                + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                + fieldOverride.byName.withProperty('custom.align', 'left')
                                + fieldOverride.byName.withPropertiesFromOptions(
                                  table.standardOptions.withUnit('ops')
                                  + table.standardOptions.color.withMode('continuous-BlPu')
                                ),
                              ])
                              + g.panel.table.standardOptions.withOverridesMixin([
                                fieldOverride.byName.new('LDAP')
                                + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                + fieldOverride.byName.withProperty('custom.align', 'left')
                                + fieldOverride.byName.withPropertiesFromOptions(
                                  table.standardOptions.withUnit('ops')
                                  + table.standardOptions.color.withMode('continuous-BlPu')
                                ),
                              ])
                              + g.panel.table.standardOptions.withOverridesMixin([
                                fieldOverride.byName.new('Negotiate')
                                + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                + fieldOverride.byName.withProperty('custom.align', 'left')
                                + fieldOverride.byName.withPropertiesFromOptions(
                                  table.standardOptions.withUnit('ops')
                                  + table.standardOptions.color.withMode('continuous-BlPu')
                                ),
                              ])
                              + g.panel.table.standardOptions.withOverridesMixin([
                                fieldOverride.byName.new('NTLM')
                                + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                + fieldOverride.byName.withProperty('custom.align', 'left')
                                + fieldOverride.byName.withPropertiesFromOptions(
                                  table.standardOptions.withUnit('ops')
                                  + table.standardOptions.color.withMode('continuous-BlPu')
                                ),
                              ])
                              + g.panel.table.standardOptions.withOverridesMixin([
                                fieldOverride.byName.new('Simple')
                                + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                + fieldOverride.byName.withProperty('custom.align', 'left')
                                + fieldOverride.byName.withPropertiesFromOptions(
                                  table.standardOptions.withUnit('ops')
                                  + table.standardOptions.color.withMode('continuous-BlPu')
                                ),
                              ])
                              + table.queryOptions.withTransformationsMixin(
                                [
                                  {
                                    id: 'joinByLabels',
                                    options: {
                                      join: [
                                        'instance',
                                      ],
                                      value: 'bind_method',
                                    },
                                  },
                                  {
                                    id: 'groupBy',
                                    options: {
                                      fields: {
                                        instance: {
                                          aggregations: [],
                                          operation: 'groupby',
                                        },
                                        digest: {
                                          aggregations: [
                                            'lastNotNull',
                                          ],
                                          operation: 'aggregate',
                                        },
                                        ds_client: {
                                          aggregations: [
                                            'lastNotNull',
                                          ],
                                          operation: 'aggregate',
                                        },
                                        ds_server: {
                                          aggregations: [
                                            'lastNotNull',
                                          ],
                                          operation: 'aggregate',
                                        },
                                        external: {
                                          aggregations: [
                                            'lastNotNull',
                                          ],
                                          operation: 'aggregate',
                                        },
                                        fast: {
                                          aggregations: [
                                            'lastNotNull',
                                          ],
                                          operation: 'aggregate',
                                        },
                                        ldap: {
                                          aggregations: [
                                            'lastNotNull',
                                          ],
                                          operation: 'aggregate',
                                        },
                                        negotiate: {
                                          aggregations: [
                                            'lastNotNull',
                                          ],
                                          operation: 'aggregate',
                                        },
                                        ntlm: {
                                          aggregations: [
                                            'lastNotNull',
                                          ],
                                          operation: 'aggregate',
                                        },
                                        simple: {
                                          aggregations: [
                                            'lastNotNull',
                                          ],
                                          operation: 'aggregate',
                                        },
                                      },
                                    },
                                  },
                                  {
                                    id: 'filterFieldsByName',
                                    options: {
                                      include: {
                                        pattern: 'instance|digest|ds_client|ds_server|external|fast|ldap|negotiate|ntlm|simple',
                                      },
                                    },
                                  },
                                  {
                                    id: 'organize',
                                    options: {
                                      renameByName:
                                        {
                                          'instance (lastNotNull)': 'Instance',
                                          'digest (lastNotNull)': 'Digest',
                                          'ds_client (lastNotNull)': 'DS_client',
                                          'ds_server (lastNotNull)': 'DS_server',
                                          'external (lastNotNull)': 'External',
                                          'fast (lastNotNull)': 'Fast',
                                          'ldap (lastNotNull)': 'LDAP',
                                          'negotiate (lastNotNull)': 'Negotiate',
                                          'ntlm (lastNotNull)': 'NTLM',
                                          'simple (lastNotNull)': 'Simple',
                                        },
                                    },
                                  },
                                ]
                              ),
      intrasiteReplicationTraffic: commonlib.panels.network.timeSeries.traffic.new(
                                     'Intrasite replication traffic',
                                     targets=[t.intrasiteReplicationTraffic],
                                     description=|||
                                       Rate of replication traffic between servers within the same site.
                                     |||
                                   )
                                   + g.panel.timeSeries.options.legend.withDisplayMode('table')
                                   + g.panel.timeSeries.options.legend.withPlacement('bottom')
                                   + g.panel.timeSeries.options.legend.withCalcs([
                                     'min',
                                     'max',
                                     'mean',
                                   ]),
      intersiteReplicationTraffic: commonlib.panels.network.timeSeries.traffic.new(
                                     'Intersite replication traffic',
                                     targets=[t.intersiteReplicationTraffic],
                                     description=|||
                                       Rate of replication traffic between servers across different sites.
                                     |||
                                   )
                                   + g.panel.timeSeries.options.legend.withDisplayMode('table')
                                   + g.panel.timeSeries.options.legend.withPlacement('bottom')
                                   + g.panel.timeSeries.options.legend.withCalcs([
                                     'min',
                                     'max',
                                     'mean',
                                   ]),
      inboundReplicationUpdates: commonlib.panels.generic.timeSeries.base.new(
                                   'Inbound replication updates',
                                   targets=[t.inboundObjectsReplicationUpdates, t.inboundPropertiesReplicationUpdates],
                                   description=|||
                                     The rate of traffic received from other replication partners.
                                   |||
                                 )
                                 + g.panel.timeSeries.options.legend.withDisplayMode('table')
                                 + g.panel.timeSeries.options.legend.withPlacement('right')
                                 + g.panel.timeSeries.options.legend.withCalcs([
                                   'min',
                                   'max',
                                   'mean',
                                 ]),
      databaseOperationsOverview: commonlib.panels.generic.table.base.new(
                                    'Database operations overview',
                                    targets=[t.databaseOperationsOverview],
                                    description=|||
                                      Distribution of different types of operations performed on the Active Directory database.
                                    |||
                                  )
                                  + g.panel.table.standardOptions.withOverridesMixin([
                                    fieldOverride.byName.new('Add')
                                    + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                    + fieldOverride.byName.withProperty('custom.align', 'left')
                                    + fieldOverride.byName.withPropertiesFromOptions(
                                      table.standardOptions.withUnit('ops')
                                      + table.standardOptions.color.withMode('continuous-BlPu')
                                    ),
                                  ])
                                  + g.panel.table.standardOptions.withOverridesMixin([
                                    fieldOverride.byName.new('Delete')
                                    + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                    + fieldOverride.byName.withProperty('custom.align', 'left')
                                    + fieldOverride.byName.withPropertiesFromOptions(
                                      table.standardOptions.withUnit('ops')
                                      + table.standardOptions.color.withMode('continuous-BlPu')
                                    ),
                                  ])
                                  + g.panel.table.standardOptions.withOverridesMixin([
                                    fieldOverride.byName.new('Modify')
                                    + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                    + fieldOverride.byName.withProperty('custom.align', 'left')
                                    + fieldOverride.byName.withPropertiesFromOptions(
                                      table.standardOptions.withUnit('ops')
                                      + table.standardOptions.color.withMode('continuous-BlPu')
                                    ),
                                  ])
                                  + g.panel.table.standardOptions.withOverridesMixin([
                                    fieldOverride.byName.new('Recycle')
                                    + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
                                    + fieldOverride.byName.withProperty('custom.align', 'left')
                                    + fieldOverride.byName.withPropertiesFromOptions(
                                      table.standardOptions.withUnit('ops')
                                      + table.standardOptions.color.withMode('continuous-BlPu')
                                    ),
                                  ])
                                  + table.queryOptions.withTransformationsMixin(
                                    [
                                      {
                                        id: 'joinByLabels',
                                        options: {
                                          join: [
                                            'instance',
                                          ],
                                          value: 'operation',
                                        },
                                      },
                                      {
                                        id: 'groupBy',
                                        options: {
                                          fields: {
                                            instance: {
                                              aggregations: [],
                                              operation: 'groupby',
                                            },
                                            add: {
                                              aggregations: [
                                                'lastNotNull',
                                              ],
                                              operation: 'aggregate',
                                            },
                                            delete: {
                                              aggregations: [
                                                'lastNotNull',
                                              ],
                                              operation: 'aggregate',
                                            },
                                            modify: {
                                              aggregations: [
                                                'lastNotNull',
                                              ],
                                              operation: 'aggregate',
                                            },
                                            recycle: {
                                              aggregations: [
                                                'lastNotNull',
                                              ],
                                              operation: 'aggregate',
                                            },
                                          },
                                        },
                                      },
                                      {
                                        id: 'organize',
                                        options: {
                                          renameByName:
                                            {
                                              'add (lastNotNull)': 'Add',
                                              'delete (lastNotNull)': 'Delete',
                                              'modify (lastNotNull)': 'Modify',
                                              'recycle (lastNotNull)': 'Recycle',
                                            },
                                        },
                                      },
                                    ]
                                  ),
      databaseOperations: commonlib.panels.generic.timeSeries.base.new(
                            'Database operations',
                            targets=[t.databaseOperations],
                            description=|||
                              The rate of database operations.
                            |||
                          )
                          + g.panel.timeSeries.standardOptions.withUnit('ops')
                          + g.panel.timeSeries.options.legend.withDisplayMode('table')
                          + g.panel.timeSeries.options.legend.withPlacement('right')
                          + g.panel.timeSeries.options.legend.withCalcs([
                            'min',
                            'max',
                            'mean',
                          ]),
    },
}
