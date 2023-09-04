local g = import './g.libsonnet';
local commonlib = import 'common/main.libsonnet';

{
    new(targets):
    {
        uptime: commonlib.panels.system.stat.uptime.new(targets=[targets.uptime]),
        cpuCount: commonlib.panels.cpu.stat.count.new(targets=[targets.cpuCount]),
        cpuUsageTs: commonlib.panels.cpu.timeSeries.utilization.new(targets=[targets.cpuUsage]),
        cpuUsageStat: commonlib.panels.cpu.stat.usage.new(targets=[targets.cpuUsage]),
        memoryTotal: commonlib.panels.memory.stat.total.new(targets=[targets.memoryTotal]),
        memoryPageTotal: commonlib.panels.memory.stat.total.new("Pagefile size", targets=[targets.memoryPageTotal]),
        memoryUsageStat: commonlib.panels.memory.stat.usage.new(targets=[targets.memoryUsage]),
        memoryUsageTs: commonlib.panels.memory.timeSeries.usage_bytes.new(targets=[targets.memoryUsage]),
        diskTotalC: commonlib.panels.filesystem.stat.total.new("Disk C: size", targets=[targets.diskTotalC]),
        diskUsage: commonlib.panels.filesystem.table.usage.new(totalTarget=targets.diskTotal, usageTarget=targets.diskUsage, groupLabel="volume"),
        diskIO: g.panel.timeSeries.new("Disk I/O")
            + g.panel.timeSeries.withTargets(targets.diskIO),
        osInfo: commonlib.panels.all.stat.info.new("OS family", targets=[targets.osInfo])
            { options+: { reduceOptions+: { fields: '/^product$/' } } },
        osVersion: commonlib.panels.all.stat.info.new("OS version", targets=[targets.osInfo])
            { options+: { reduceOptions+: { fields: '/^version$/' } } },
        hostname: commonlib.panels.all.stat.info.new("Hostname", targets=[targets.osInfo])
            { options+: { reduceOptions+: { fields: '/^hostname$/' } } },
        networkInterfacesOverview: g.panel.table.new("Network interfaces overview"),
        networkInterfaceCarrierStatus: g.panel.statusHistory.new("Network Interfaces Carrier Status"),
        networkErrors: commonlib.panels.network.timeSeries.errors.new("Network errors", targets=[targets.networkErrors])
            + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),
        networkDropped: commonlib.panels.network.timeSeries.dropped.new(targets=[targets.networkDropped])
            + commonlib.panels.network.timeSeries.errors.withNegateOutPackets(),
        networkUsage: commonlib.panels.network.timeSeries.traffic.new(targets=[targets.networkUsage])
            + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
        networkPackets: commonlib.panels.network.timeSeries.packets.new(targets=[targets.networkPackets])
            + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
        networkMulticast: commonlib.panels.network.timeSeries.multicast.new(targets=[targets.networkMulticast])
            + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets(),
    }
}