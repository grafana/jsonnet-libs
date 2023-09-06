local g = import './g.libsonnet';
local commonlib = import 'common/main.libsonnet';

{
    new(targets):
    {
        local t = targets,
        uptime: commonlib.panels.system.stat.uptime.new(targets=[t.uptime]),
        cpuCount: commonlib.panels.cpu.stat.count.new(targets=[t.cpuCount]),
        cpuUsageTs: commonlib.panels.cpu.timeSeries.utilization.new(targets=[t.cpuUsage]),
        cpuUsageStat: commonlib.panels.cpu.stat.usage.new(targets=[t.cpuUsage]),
        memoryTotalBytes: commonlib.panels.memory.stat.total.new(targets=[t.memoryTotalBytes]),
        memoryPageTotalBytes: commonlib.panels.memory.stat.total.new("Pagefile size", targets=[t.memoryPageTotalBytes]),
        memoryUsageStatPercent: commonlib.panels.memory.stat.usage.new(targets=[t.memoryUsagePercent]),
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
        diskIOBytesPerSec: commonlib.panels.disk.timeSeries.ioBytesPerSec.new(targets=[t.diskIOreadBytesPerSec,t.diskIOwriteBytesPerSec]),
        osInfo: commonlib.panels.all.stat.info.new("OS family", targets=[t.osInfo])
            { options+: { reduceOptions+: { fields: '/^product$/' } } },
        osVersion: commonlib.panels.all.stat.info.new("OS version", targets=[t.osInfo])
            { options+: { reduceOptions+: { fields: '/^version$/' } } },
        hostname: commonlib.panels.all.stat.info.new("Hostname", targets=[t.osInfo])
            { options+: { reduceOptions+: { fields: '/^hostname$/' } } },
        networkInterfacesOverview: g.panel.table.new("Network interfaces overview"),
        networkInterfaceCarrierStatus: g.panel.statusHistory.new("Network Interfaces Carrier Status"),
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