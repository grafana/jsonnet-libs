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
    {
      'overview.json':
        g.dashboard.new(prefix + 'Dragonfly overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              // KPI row: 3 stat panels fill full width (8+8+8=24) per review-checklist
              panels.uptime { gridPos+: { w: 8, h: 4 } },
              panels.connectedClients { gridPos+: { w: 8, h: 4 } },
              panels.memoryUtilization { gridPos+: { w: 8, h: 4 } },
              g.panel.row.new('Commands'),
              panels.commandsRate { gridPos+: { w: 12 } },
              panels.replyRate { gridPos+: { w: 12 } },
              panels.replyLatency { gridPos+: { w: 12 } },
              panels.commandsDuration { gridPos+: { w: 12 } },
              g.panel.row.new('Memory'),
              panels.memory { gridPos+: { w: 24 } },
              g.panel.row.new('Keyspace hits'),
              panels.keyspaceHitsMisses { gridPos+: { w: 12 } },
              panels.keyspaceHitRate { gridPos+: { w: 12 } },
              g.panel.row.new('Keyspace data'),
              panels.dbKeys { gridPos+: { w: 12 } },
              panels.evictedExpiredKeys { gridPos+: { w: 12 } },
              g.panel.row.new('Network'),
              panels.networkTraffic { gridPos+: { w: 24 } },
              g.panel.row.new('Pipeline'),
              panels.pipelineQueueLength { gridPos+: { w: 12 } },
              panels.connectedClientsTimeSeries { gridPos+: { w: 12 } },
            ], 12, 6
          )
        )
        + root.applyCommon(vars.multiInstance, uid + '-overview', tags, links { dragonflyOverview+:: {} }, annotations, timezone, refresh, period),
      'clusterOverview.json':
        g.dashboard.new(prefix + 'Dragonfly cluster overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              g.panel.row.new('Alerts'),
              panels.alertsPanel { gridPos+: { w: 12 } },
              panels.commandsRate { gridPos+: { w: 12 } },
              g.panel.row.new('Instance metrics'),
              panels.connectedClientsTimeSeries { gridPos+: { w: 12 } },
              panels.memory { gridPos+: { w: 12 } },
              g.panel.row.new('Keyspace and network'),
              panels.keyspaceHitRate { gridPos+: { w: 24 } },
              panels.networkTraffic { gridPos+: { w: 24 } },
            ], 12, 6
          )
        )
        + root.applyCommon(vars.multiInstance, uid + '-cluster-overview', tags, links { dragonflyClusterOverview+:: {} }, annotations, timezone, refresh, period),
    },
  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars),
}
