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
            // hide link to self
            + this.applyCommon(vars.multiInstance, uid+'-fleet', tags, links + { backToFleet+:: {}, backToOverview+:: {} }, annotations),
        overview: g.dashboard.new(prefix+"Windows overview")
            + g.dashboard.withUid('overview')
            + g.dashboard.withPanels(
                g.util.grid.wrapPanels(
                    [
                        g.panel.row.new("Overview"),
                        panels.uptime,
                        panels.hostname,// {id: 1001},
                        panels.osVersion,
                        // + g.panel.stat.withDatasource(
                        //     g.panel.stat.datasource.withType("datasource")
                        //     + g.panel.stat.datasource.withUid("-- Dashboard --")
                        // )
                        // + {targets:: []}
                        // + g.panel.stat.withTargets(
                        //     // {
                        //     //     "uid": "-- Dashboard --",
                        //     //     "type": "datasource"
                        //     // },
                        //     [{panelId: 1001, format: 'table'}],
                        // ),
                        panels.osInfo,
                        panels.cpuCount,
                        panels.memoryTotal,
                        panels.memoryPageTotal,
                        panels.diskTotalC,
                        g.panel.row.new("CPU"),
                        panels.cpuUsageStat {gridPos+: { w:6, h:6}},
                        panels.cpuUsageTs {gridPos+: { w:18, h:6}},
                        g.panel.row.new("Memory"),
                        panels.memoryUsageStat {gridPos+: { w:6, h:6}},
                        panels.memoryUsageTs {gridPos+: { w:18, h:6}},
                        g.panel.row.new("Disk"),
                        g.panel.timeSeries.new("test12") {gridPos+: { w:12, h:8}},
                        g.panel.timeSeries.new("test13") {gridPos+: { w:12, h:8}},
                        g.panel.row.new("Network"),
                        g.panel.timeSeries.new("test12") {gridPos+: { w:12, h:8}},
                        g.panel.timeSeries.new("test13") {gridPos+: { w:12, h:8}},
                    ],6,2)
            )
            + this.applyCommon(vars.singleInstance, uid+'-overview', tags, links + { backToOverview+:: {} }, annotations),
        network: g.dashboard.new(prefix+"Windows network")
            + this.applyCommon(vars.singleInstance, uid+'-network', tags, links, annotations),

        disks: g.dashboard.new(prefix+"Windows disks and filesystems")
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
