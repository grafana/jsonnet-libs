local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  local root = self,
  new(this):
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = this.config.uid;
    local vars = commonlib.variables.new(
      filteringSelector=this.config.filteringSelector,
      groupLabels=this.config.groupLabels,
      instanceLabels=this.config.instanceLabels,
      varMetric='discourse_page_views',
      customAllValue='.+',
      enableLokiLogs=this.config.enableLokiLogs,
    );
    local annotations = {};
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;

    {
      'discourse-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withDescription('Overview of Discourse application performance and traffic.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.overviewRow,
                this.grafana.rows.latencyRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '-overview',
          tags,
          links { overview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'discourse-jobs.json':
        g.dashboard.new(prefix + ' jobs processing')
        + g.dashboard.withDescription('Discourse job processing, workers, and memory usage.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.jobStatsRow,
                this.grafana.rows.jobCountsRow,
                this.grafana.rows.jobDurationRow,
                this.grafana.rows.memoryRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '-jobs',
          tags,
          links { jobs+:: {} },
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
    + g.dashboard.withAnnotations(std.objectValues(annotations))
    + g.dashboard.graphTooltip.withSharedCrosshair(),
}
