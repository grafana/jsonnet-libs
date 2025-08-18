local g = import './g.libsonnet';

{
  local root = self,
  new(this)::
    local prefix = this.config.dashboardNamePrefix;
    local tags = this.config.dashboardTags;
    local uid = this.config.uid;
    local vars = this.grafana.variables;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local links = this.grafana.links;
    local annotations = this.grafana.annotations;

    {
      'cloudflare-zone-overview.json':
        g.dashboard.new(prefix + ' zone overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.zoneOverview + g.panel.row.withCollapsed(false),
                this.grafana.rows.zoneBandwidth + g.panel.row.withCollapsed(false),
                this.grafana.rows.zoneVisitors + g.panel.row.withCollapsed(false),
                this.grafana.rows.zoneStatusLocation + g.panel.row.withCollapsed(false),
                this.grafana.rows.pools + g.panel.row.withCollapsed(false),
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [vars.geoMetric],
          uid + '_cloudflare_zone_overview',
          tags,
          links { cloudflareZoneOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'cloudflare-worker-overview.json':
        g.dashboard.new(prefix + ' worker overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.workers + g.panel.row.withCollapsed(false),
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_cloudflare_worker_overview',
          tags,
          links { cloudflareWorkerOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'cloudflare-geomap-overview.json':
        g.dashboard.new(prefix + ' Geomap overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              this.grafana.panels.geoMetricsByCountryTablePanel + g.panel.table.gridPos.withW(24) + g.panel.table.gridPos.withH(7),
              this.grafana.panels.geoMetricByCountryGeomapPanel + g.panel.geomap.gridPos.withW(24) + g.panel.geomap.gridPos.withH(12),
            ]
          )
        )
        + root.applyCommon(
          vars.multiInstance + [vars.geoMetric],
          uid + '_cloudflare_geomap_overview',
          tags,
          links { cloudflareGeomapOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
    },
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
