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
                        g.panel.stat.new("test1"),
                        g.panel.stat.new("test2"),
                        g.panel.stat.new("test3"),
                        g.panel.stat.new("test4"),
                        g.panel.stat.new("test5"),
                        g.panel.stat.new("test6"),
                        g.panel.stat.new("test7"),
                        g.panel.stat.new("test8"),
                        g.panel.row.new("CPU"),
                        g.panel.timeSeries.new("test9")
                        + g.panel.stat.gridPos.withW(6)
                        + g.panel.stat.gridPos.withH(6),
                        g.panel.timeSeries.new("test10")
                        + g.panel.stat.gridPos.withW(12)
                        + g.panel.stat.gridPos.withH(6),
                        g.panel.timeSeries.new("test11")
                        + g.panel.stat.gridPos.withW(6)
                        + g.panel.stat.gridPos.withH(6),
                        g.panel.row.new("Memory"),
                        g.panel.timeSeries.new("test12") {gridPos+: { w:6, h:6}},
                        g.panel.timeSeries.new("test13") {gridPos+: { w:18, h:6}},
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
