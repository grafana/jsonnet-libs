local g = import './g.libsonnet';
{
    local this = self,
    new(
        prefix,
        links,
        tags,
        uid,
        vars,
        annotations,
        panels,
        ):
    {
        local stat = g.panel.stat,
        fleet: 
            local title=prefix+"Windows fleet overview";
            g.dashboard.new(title)
            + g.dashboard.withPanels(
                g.util.grid.wrapPanels(
                    [
                        // g.panel.row.new("Overview"),
                        g.panel.table.new("Fleet overview") {gridPos+: {w: 24, h:16}},
                        g.panel.timeSeries.new("CPU") {gridPos+: {w: 24}},
                        g.panel.timeSeries.new("Memory") {gridPos+: {w: 24}},
                        panels.diskIOBytesPerSec {gridPos+: {w: 12}},
                        panels.diskUsage {gridPos+: {w: 12}},
                        panels.networkErrorsPerSec {gridPos+: {w: 24}},
                    ],12,7)
            )
            // hide link to self
            + this.applyCommon(vars.multiInstance, uid+'-fleet', tags, links + { backToFleet+:: {}, backToOverview+:: {} }, annotations),
        overview: g.dashboard.new(prefix+"Windows overview")
            + g.dashboard.withUid('overview')
            + g.dashboard.withPanels(
                g.util.grid.wrapPanels(
                    [
                        g.panel.row.new("Overview"),
                        panels.uptime,
                        panels.hostname,
                        panels.osVersion,
                        panels.osInfo,
                        panels.cpuCount,
                        panels.memoryTotalBytes,
                        panels.memoryPageTotalBytes,
                        panels.diskTotalC,
                        g.panel.row.new("CPU"),
                        panels.cpuUsageStat {gridPos+: { w:6, h:6}},
                        panels.cpuUsageTs {gridPos+: { w:18, h:6}},
                        g.panel.row.new("Memory"),
                        panels.memoryUsageStatPercent {gridPos+: { w:6, h:6}},
                        panels.memoryUsageTsBytes {gridPos+: { w:18, h:6}},
                        g.panel.row.new("Disk"),
                        panels.diskIOBytesPerSec {gridPos+: { w:12, h:8}},
                        panels.diskUsage {gridPos+: { w:12, h:8}},
                        g.panel.row.new("Network"),
                        panels.networkUsagePerSec {gridPos+: { w:12, h:8}},
                        panels.networkErrorsPerSec {gridPos+: { w:12, h:8}},
                    ],6,2)
            )
            + this.applyCommon(vars.singleInstance, uid+'-overview', tags, links + { backToOverview+:: {} }, annotations),
        network: g.dashboard.new(prefix+"Windows network")
            + g.dashboard.withPanels(
                g.util.grid.wrapPanels(
                    [
                        g.panel.row.new("Network"),
                        panels.networkInterfacesOverview {gridPos+: {w: 24}},
                        panels.networkUsagePerSec,
                        panels.networkInterfaceCarrierStatus,
                        panels.networkErrorsPerSec,
                        panels.networkDroppedPerSec,
                        panels.networkPacketsPerSec,
                        panels.networkMulticast,
                    ],12,7)
            )
            + this.applyCommon(vars.singleInstance, uid+'-network', tags, links, annotations),

        disks: g.dashboard.new(prefix+"Windows disks and filesystems")
            + g.dashboard.withPanels(
                g.util.grid.wrapPanels(
                    [
                        g.panel.row.new("Filesystem"),
                        panels.networkUsagePerSec,
                        panels.networkInterfaceCarrierStatus,
                        panels.networkErrorsPerSec,
                        panels.networkDroppedPerSec,
                        g.panel.row.new("Disk"),
                        panels.networkPacketsPerSec,
                        panels.networkMulticast,
                        panels.networkPacketsPerSec,
                        panels.networkMulticast,
                    ],12,7)
            )
            + this.applyCommon(vars.singleInstance, uid+'-disks', tags, links, annotations),

        logs: g.dashboard.new(prefix+"Windows logs")
            + this.applyCommon(vars.multiInstance, uid+'-logs', tags, links, annotations),
    },
    applyCommon(vars, uid, tags, links, annotations):
        g.dashboard.withTags(tags)
        + g.dashboard.withUid(g.util.string.slugify(uid))
        + g.dashboard.withLinks(std.objectValues(links))
        + g.dashboard.withVariables(vars)
        + g.dashboard.withAnnotations(std.objectValues(annotations))
}
