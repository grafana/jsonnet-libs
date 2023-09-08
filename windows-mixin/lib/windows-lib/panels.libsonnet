local g = import './g.libsonnet';
local commonlib = import 'common/main.libsonnet';

{
    new(this):
    {
        local t = this.targets,
        local table = g.panel.table,
        local fieldOverride = g.panel.table.fieldOverride,
        local instanceLabel = 'instance',
        fleetOverviewTable: g.panel.table.new("Fleet overview")
            + table.queryOptions.withTargets([
                t.osInfo
                + g.query.prometheus.withFormat('table')
                + g.query.prometheus.withInstant(true)
                + g.query.prometheus.withRefId("OS Info"),
                t.uptime
                + g.query.prometheus.withFormat('table')
                + g.query.prometheus.withInstant(true)
                + g.query.prometheus.withRefId("Uptime"),
                t.cpuCount
                + g.query.prometheus.withFormat('table')
                + g.query.prometheus.withInstant(true)
                + g.query.prometheus.withRefId("CPU count"),
                t.cpuUsage
                + g.query.prometheus.withFormat('table')
                + g.query.prometheus.withInstant(true)
                + g.query.prometheus.withRefId("CPU usage"),
                t.memoryTotalBytes
                + g.query.prometheus.withFormat('table')
                + g.query.prometheus.withInstant(true)
                + g.query.prometheus.withRefId("Memory total"),
                t.memoryUsagePercent
                + g.query.prometheus.withFormat('table')
                + g.query.prometheus.withInstant(true)
                + g.query.prometheus.withRefId("Memory usage"),
                t.diskTotalC
                + g.query.prometheus.withFormat('table')
                + g.query.prometheus.withInstant(true)
                + g.query.prometheus.withRefId("Disk C: total"),
                t.diskUsageCPercent
                + g.query.prometheus.withFormat('table')
                + g.query.prometheus.withInstant(true)
                + g.query.prometheus.withRefId("Disk C: used"),
            ])
            + commonlib.panels.system.table.uptime.stylizeByName('Uptime')
            + table.standardOptions.withOverrides([
            fieldOverride.byName.new('CPU count')
            + fieldOverride.byName.withProperty('custom.width','120'),
            fieldOverride.byName.new('CPU usage')
            + fieldOverride.byName.withProperty('custom.width','120')
            + fieldOverride.byName.withProperty('custom.displayMode','basic')
            + fieldOverride.byName.withPropertiesFromOptions(
                commonlib.panels.cpu.timeSeries.utilization.stylize()
            ),
            fieldOverride.byName.new('Memory total')
            + fieldOverride.byName.withProperty('custom.width','120')
            + fieldOverride.byName.withPropertiesFromOptions(
                table.standardOptions.withUnit('bytes')
            ),
            fieldOverride.byName.new('Memory usage')
            + fieldOverride.byName.withProperty('custom.width','120')
            + fieldOverride.byName.withProperty('custom.displayMode','basic')
            + fieldOverride.byName.withPropertiesFromOptions(
                table.standardOptions.withMax(100)
                + table.standardOptions.withMin(0)
                + table.standardOptions.withUnit('percent')
            ),
            fieldOverride.byName.new('Disk C: total')
            + fieldOverride.byName.withProperty('custom.width','120')
            + fieldOverride.byName.withPropertiesFromOptions(
                table.standardOptions.withUnit('bytes')
            ),
            fieldOverride.byName.new('Disk C: used')
            + fieldOverride.byName.withProperty('custom.width','120')
            + fieldOverride.byName.withPropertiesFromOptions(
                table.standardOptions.withUnit('percent')
            ),
            ])
            + table.queryOptions.withTransformationsMixin(
                        [
                            {
                                "id": "joinByField",
                                "options": {
                                  "byField": instanceLabel,
                                  "mode": "outer"
                                }
                            },
                            {
                                "id": "filterFieldsByName",
                                "options": {
                                    "include": {
                                      "pattern": instanceLabel+"|product|^hostname$|Value.+"
                                    }
                                }
                            },
                            {
                                id: 'organize',
                                options: {
                                    excludeByName: {
                                        'Value #OS Info': true,
                                    },
                                    indexByName: {},
                                    renameByName: {
                                        'product': 'Product',
                                    },
                                },
                            },
                            {
                                "id": "renameByRegex",
                                "options": {
                                    "regex": "Value #(.*)",
                                    "renamePattern": "$1"
                                }
                            }
                        ]),
        uptime: commonlib.panels.system.stat.uptime.new(targets=[t.uptime]),
        cpuCount: commonlib.panels.cpu.stat.count.new(targets=[t.cpuCount]),
        cpuUsageTs: commonlib.panels.cpu.timeSeries.utilization.new(targets=[t.cpuUsage]),
        cpuUsageTopk: commonlib.panels.all.timeSeries.topkPercentage.new(
            title="CPU usage",
            target=t.cpuUsage,
            topk=25,
            legendLabels=this.config.instanceLabels,
        ),
        cpuUsageStat: commonlib.panels.cpu.stat.usage.new(targets=[t.cpuUsage]),
        memoryTotalBytes: commonlib.panels.memory.stat.total.new(targets=[t.memoryTotalBytes]),
        memoryPageTotalBytes: commonlib.panels.memory.stat.total.new("Pagefile size", targets=[t.memoryPageTotalBytes]),
        memoryUsageStatPercent: commonlib.panels.memory.stat.usage.new(targets=[t.memoryUsagePercent]),
        memotyUsageTopKPercent: commonlib.panels.all.timeSeries.topkPercentage.new(
            title="Memory usage",
            target=t.memoryUsagePercent,
            topk=25,
            legendLabels=this.config.instanceLabels,
        ),
        memoryUsageTsBytes: commonlib.panels.memory.timeSeries.usageBytes.new(targets=[t.memoryUsedBytes, t.memoryTotalBytes]),
        diskTotalC: commonlib.panels.filesystem.stat.total.new("Disk C: size", targets=[t.diskTotalC]),
        diskUsage: commonlib.panels.filesystem.table.usage.new(
            totalTarget=
            (t.diskTotal
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true)),
            usageTarget=t.diskUsage
            + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withInstant(true),
            groupLabel="volume"),
        diskUsagePercentTopK: commonlib.panels.all.timeSeries.topkPercentage.new(
            title="Disk space usage",
            target=t.diskUsagePercent,
            topk=25,
            legendLabels=this.config.instanceLabels + ['volume'],
        ),
        diskIOBytesPerSec: commonlib.panels.disk.timeSeries.ioBytesPerSec.new(targets=[t.diskIOreadBytesPerSec,t.diskIOwriteBytesPerSec]),
        diskIOutilPercentTopK: 
        commonlib.panels.all.timeSeries.topkPercentage.new(
            title="Disk IO",
            target=t.diskIOutilization,
            topk=25,
            legendLabels=this.config.instanceLabels + ['volume'],
        ),
        osInfo: commonlib.panels.all.stat.info.new("OS family", targets=[t.osInfo])
            { options+: { reduceOptions+: { fields: '/^product$/' } } },
        osVersion: commonlib.panels.all.stat.info.new("OS version", targets=[t.osInfo])
            { options+: { reduceOptions+: { fields: '/^version$/' } } },
        hostname: commonlib.panels.all.stat.info.new("Hostname", targets=[t.osInfo])
            { options+: { reduceOptions+: { fields: '/^hostname$/' } } },
        networkInterfacesOverview: g.panel.table.new("Network interfaces overview"),
        networkInterfaceCarrierStatus: g.panel.statusHistory.new("Network Interfaces Carrier Status"),
        networkErrorsAndDroppedPerSec: 
            commonlib.panels.network.timeSeries.errors.new(
                'Network errors and dropped packets',
                targets=std.map(
                function(t) t + 
                {
                    expr: '('+t.expr+')>0.5',
                    legendFormat: "{{" + this.config.instanceLabels[0]+"}}: "+std.get(t,'legendFormat',"{{ nic }}")
                },
                    [
                        t.networkOutErrorsPerSec,
                        t.networkInErrorsPerSec,
                        t.networkInUknownPerSec,
                        t.networkOutDroppedPerSec,
                        t.networkInDroppedPerSec,
                    ])
            ),
        
        networkErrorsPerSec: commonlib.panels.network.timeSeries.errors.new("Network errors",
            targets=[t.networkInErrorsPerSec,t.networkOutErrorsPerSec,t.networkInUknownPerSec])
            + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),
        networkDroppedPerSec: commonlib.panels.network.timeSeries.dropped.new(
            targets=[t.networkInDroppedPerSec,t.networkOutDroppedPerSec])
            + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),
        networkUsagePerSec: commonlib.panels.network.timeSeries.traffic.new(
            targets=[t.networkInBitPerSec,t.networkOutBitPerSec])
            + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
        networkPacketsPerSec: commonlib.panels.network.timeSeries.packets.new(
            targets=[t.networkInPacketsPerSec,t.networkOutPacketsPerSec])
            + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
        networkMulticast: commonlib.panels.network.timeSeries.multicast.new(targets=[t.networkMulticast])
            + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
    }
}