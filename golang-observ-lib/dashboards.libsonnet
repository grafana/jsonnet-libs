local g = import './g.libsonnet';
{
  local root = self,
  new(this):
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local panels = this.grafana.panels;
    local stat = g.panel.stat;
    {
      golangruntime:
        g.dashboard.new(prefix + 'Golang runtime')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.memoryReservedMemory,
              panels.memoryStackUse,
              panels.memoryOtherReservations,
              panels.memoryHeap,
              panels.memoryAllocationRate,
              panels.memoryObjectAllocationRate,
              panels.goroutines,
              panels.garbageCollector,
              panels.nextGC,
            ], 12, 6
          )
        )
        + root.applyCommon(vars.singleInstance, uid + '-golangruntime', tags, links { backToOverview+:: {} }, annotations, timezone, refresh, period),
    },

  //Apply common options(uids, tags, annotations etc..) to all dashboards above
  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),

}
