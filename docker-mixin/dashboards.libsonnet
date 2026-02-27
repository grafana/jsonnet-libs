local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(this):
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local vars =
      // combine single choice 'instance' with multichoice 'name'
      std.setUnion(
        this.signals.machine.getVariablesSingleChoice(),
        this.signals.container.getVariablesMultiChoice(),
        keyF=function(x) x.name
      );
    local annotations = {};
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    {
      'docker-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'Docker overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            this.grafana.rows.overview
            + this.grafana.rows.compute
            + this.grafana.rows.network
            + this.grafana.rows.disks
          )
        )
        + root.applyCommon(
          vars=vars,
          uid=this.config.uid + '-overview',
          tags=tags,
          links=links { dockerOverview+:: {} },
          annotations=annotations,
          timezone=timezone,
          refresh=refresh,
          period=period
        ),
    }
    +
    (if this.config.enableLokiLogs then
       {
         'docker-logs.json':
           local logsDashboard =
             logslib.new(
               this.config.dashboardNamePrefix + 'Docker logs',
               datasourceName='loki_datasource',
               datasourceRegex='',
               filterSelector=this.config.logsFilteringSelector,
               labels=this.config.logsLabels,
               formatParser=this.config.logsFormatParser,
               showLogsVolume=this.config.showLogsVolume,
               logsVolumeGroupBy=this.config.logsVolumeGroupBy,
               extraFilters=this.config.logsExtraFilters
             ).dashboards.logs;
           logsDashboard
           + root.applyCommon(
             vars=logsDashboard.templating.list,
             uid=this.config.uid + '-logs',
             tags=tags,
             links=links { logs+:: {} },
             annotations=annotations,
             timezone=timezone,
             refresh=refresh,
             period=period
           ),
       } else {}),

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
