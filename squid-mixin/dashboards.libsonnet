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
      varMetric='squid_server_http_requests_total',
      customAllValue='.+',
      enableLokiLogs=this.config.enableLokiLogs,
    );
    local annotations = {};
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;

    {
      'squid-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withDescription('')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.clientRow,
                this.grafana.rows.serverRow,
              ]
              +
              if this.config.enableLokiLogs then
                [this.grafana.rows.logsRow]
              else
                []
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '-overview',
          tags,
          links,
          annotations,
          timezone,
          refresh,
          period
        ),
    },

  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks([links[key].asDashboardLink() for key in std.objectFields(links)])
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),
}
