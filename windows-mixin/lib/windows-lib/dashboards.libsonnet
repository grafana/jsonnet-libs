local g = import './g.libsonnet';

{
    local this = self,
    new(
        prefix,
        links,
        tags,
        uid,
        vars):
    {
        fleet: 
            local title=prefix+"Windows fleet overview";
            g.dashboard.new(title)
            // hide link to self
            + this.applyCommon(vars.multiInstance, uid+'-fleet', tags, links + { backToFleet+:: {}, backToOverview+:: {} }),
        overview: g.dashboard.new(prefix+"Windows overview")
            + g.dashboard.withUid('overview')
            + this.applyCommon(vars.singleInstance, uid+'-overview', tags, links + { backToOverview+:: {} }),
        network: g.dashboard.new(prefix+"Windows network")
            + this.applyCommon(vars.singleInstance, uid+'-network', tags, links),

        disks: g.dashboard.new(prefix+"Windows disks and filesystems")
            + this.applyCommon(vars.singleInstance, uid+'-disks', tags, links),

        logs: g.dashboard.new(prefix+"Windows logs")
            + this.applyCommon(vars.multiInstance, uid+'-logs', tags, links),
    },
    applyCommon(vars, uid, tags, links):
        g.dashboard.withTags(tags)
        + g.dashboard.withUid(g.util.string.slugify(uid))
        + g.dashboard.withLinks(std.objectValues(links))
        + g.dashboard.withVariables(vars)
}