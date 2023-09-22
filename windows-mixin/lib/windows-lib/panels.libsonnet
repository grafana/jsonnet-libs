local g = import './g.libsonnet';
local commonlib = import 'common/main.libsonnet';

{
  new(this):
    {
      local t = this.targets,
      local table = g.panel.table,
      local fieldOverride = g.panel.table.fieldOverride,
      local instanceLabel = this.config.instanceLabels[0],
      fleetOverviewTable: g.panel.table.new('Fleet overview')
                          + table.queryOptions.withTargets([
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
                            + g.query.prometheus.withRefId('CPU count'),
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
                          ])
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
                                url: 'd/%s?var-%s=${__data.fields.%s}&${__url_time_range}' % [this.dashboards.overview.uid, instanceLabel, instanceLabel],
                              },
                            ]),
                            fieldOverride.byRegexp.new(std.join('|', this.config.groupLabels))
                            + fieldOverride.byRegexp.withProperty('custom.filterable', true)
                            + fieldOverride.byRegexp.withProperty('links', [
                              {
                                targetBlank: false,
                                title: 'Filter by ${__field.name}',
                                url: 'd/%s?var-${__field.name}=${__value.text}&${__url_time_range}' % [this.dashboards.fleet.uid],
                              },
                            ]),
                            fieldOverride.byName.new('CPU count')
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
                                  renameByName: {
                                    product: 'Product',
                                    [instanceLabel]: 'Instance',
                                    hostname: 'Hostname',
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
        commonlib.panels.all.timeSeries.base.new(
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
        commonlib.panels.all.timeSeries.base.new(
          'System calls and exceptions',
          targets=[
            t.windowsSystemExceptions,
            t.windowsSystemCalls,
          ],
        ),
      systemThreads:
        commonlib.panels.all.timeSeries.base.new(
          'System threads',
          targets=[
            t.windowsSystemThreads,
          ],
        ),
      timeNtpStatus: commonlib.panels.system.statusHistory.ntp.new(
        'NTP status',
        targets=[t.timeNtpStatus],
        description=''
      ),
      timeNtpDelay: commonlib.panels.all.timeSeries.base.new(
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
                    + g.panel.timeSeries.standardOptions.withUnit('seconds'),
      cpuCount: commonlib.panels.cpu.stat.count.new(targets=[t.cpuCount]),
      cpuUsageTs: commonlib.panels.cpu.timeSeries.utilization.new(targets=[t.cpuUsage]),
      cpuUsageTopk: commonlib.panels.all.timeSeries.topkPercentage.new(
        title='CPU usage',
        target=t.cpuUsage,
        topk=25,
        instanceLabels=this.config.instanceLabels,
        drillDownDashboardUid=this.dashboards.overview.uid,
      ),
      cpuUsageStat: commonlib.panels.cpu.stat.usage.new(targets=[t.cpuUsage]),
      cpuUsageByMode: commonlib.panels.cpu.timeSeries.utilizationByMode.new(
        targets=[t.cpuUsageByMode],
        description=|||
          CPU usage by different modes.
        |||
      ),
      // TODO add why it is important, consider alert
      // https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-2000-server/cc940375(v=technet.10)
      cpuQueue: commonlib.panels.all.timeSeries.base.new('CPU average queue', targets=[t.cpuQueue]),
      memoryTotalBytes: commonlib.panels.memory.stat.total.new(targets=[t.memoryTotalBytes]),
      memoryPageTotalBytes: commonlib.panels.memory.stat.total.new('Pagefile size', targets=[t.memoryPageTotalBytes]),
      memoryUsageStatPercent: commonlib.panels.memory.stat.usage.new(targets=[t.memoryUsagePercent]),
      memotyUsageTopKPercent: commonlib.panels.all.timeSeries.topkPercentage.new(
        title='Memory usage',
        target=t.memoryUsagePercent,
        topk=25,
        instanceLabels=this.config.instanceLabels,
        drillDownDashboardUid=this.dashboards.overview.uid,
      ),
      memoryUsageTsBytes: commonlib.panels.memory.timeSeries.usageBytes.new(targets=[t.memoryUsedBytes, t.memoryTotalBytes]),
      diskTotalC: commonlib.panels.filesystem.stat.total.new('Disk C: size', targets=[t.diskTotalC]),
      diskUsage: commonlib.panels.filesystem.table.usage.new(
        totalTarget=
        (t.diskTotal
         + g.query.prometheus.withFormat('table')
         + g.query.prometheus.withInstant(true)),
        usageTarget=t.diskUsage
                    + g.query.prometheus.withFormat('table')
                    + g.query.prometheus.withInstant(true),
        groupLabel='volume'
      ),
      diskUsagePercentTopK: commonlib.panels.all.timeSeries.topkPercentage.new(
        title='Disk space usage',
        target=t.diskUsagePercent,
        topk=25,
        instanceLabels=this.config.instanceLabels + ['volume'],
        drillDownDashboardUid=this.dashboards.overview.uid,
      ),
      diskIOBytesPerSec: commonlib.panels.disk.timeSeries.ioBytesPerSec.new(targets=[t.diskIOreadBytesPerSec, t.diskIOwriteBytesPerSec]),
      diskIOutilPercentTopK:
        commonlib.panels.all.timeSeries.topkPercentage.new(
          title='Disk IO',
          target=t.diskIOutilization,
          topk=25,
          instanceLabels=this.config.instanceLabels + ['volume'],
          drillDownDashboardUid=this.dashboards.overview.uid,
        ),
      osInfo: commonlib.panels.all.stat.info.new('OS family', targets=[t.osInfo])
              { options+: { reduceOptions+: { fields: '/^product$/' } } },
      osVersion: commonlib.panels.all.stat.info.new('OS version', targets=[t.osInfo])
                 { options+: { reduceOptions+: { fields: '/^version$/' } } },
      osTimezone: commonlib.panels.all.stat.info.new('Timezone', targets=[t.osTimezone])
                  { options+: { reduceOptions+: { fields: '/^timezone$/' } } },
      hostname: commonlib.panels.all.stat.info.new('Hostname', targets=[t.osInfo])
                { options+: { reduceOptions+: { fields: '/^hostname$/' } } },
      networkInterfacesOverview: g.panel.table.new('Network interfaces overview'),
      networkInterfaceCarrierStatus: g.panel.statusHistory.new('Network Interfaces Carrier Status'),
      networkErrorsAndDroppedPerSec:
        commonlib.panels.network.timeSeries.errors.new(
          'Network errors and dropped packets',
          targets=std.map(
            function(t) t
                        {
              expr: '(' + t.expr + ')>0.5',
              legendFormat: '{{' + this.config.instanceLabels[0] + '}}: ' + std.get(t, 'legendFormat', '{{ nic }}'),
            },
            [
              t.networkOutErrorsPerSec,
              t.networkInErrorsPerSec,
              t.networkInUknownPerSec,
              t.networkOutDroppedPerSec,
              t.networkInDroppedPerSec,
            ]
          )
        ),

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
      // networkMulticast: commonlib.panels.network.timeSeries.multicast.new(targets=[t.networkMulticast])
      //                   + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
    },
}
