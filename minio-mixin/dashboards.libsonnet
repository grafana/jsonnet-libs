local g = import './g.libsonnet';

{
  local root = self,

  new(this):
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local rows = this.grafana.rows;
    {
      'minio-dashboardv1.json':
        g.dashboard.new(prefix + 'distributed cluster metrics')
        + g.dashboard.withEditable(false)
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([rows.overview, rows.storage, rows.buckets, rows.requests, rows.performance])
          ),
          setPanelIDs=false
        )
        + root.applyCommon(
          // The disk variable comes from the storage group, after the shared job/instance variables.
          this.signals.overview.getVariablesMultiChoice()
          + [v for v in this.signals.storage.getVariablesMultiChoice() if v.name == 'disk'],
          // Legacy uid, kept so existing links and bookmarks still resolve.
          if this.config.uid == 'minio' then '9f12bb5e582db0925a22a1b318bcc8b7' else this.config.uid + '-overview',
          tags,
          links { overview+:: {} },
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
