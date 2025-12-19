local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';


{
  local root = self,
  new(this)::
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = this.config.uid;
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local root = self;

    {
      'sap-hana-system-overview.json':
        g.dashboard.new(prefix + ' system overview')
        + g.dashboard.withDescription('SAP HANA system overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.systemReplicationRow,
                this.grafana.rows.systemResourcesRow,
                this.grafana.rows.systemIORow,
                this.grafana.rows.systemPerformanceRow,
                this.grafana.rows.systemAlertsRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '-system-overview',
          tags,
          links { sapHanaOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      'sap-hana-instance-overview.json':
        g.dashboard.new(prefix + ' instance overview')
        + g.dashboard.withDescription('SAP HANA instance overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.instanceResourcesRow,
                this.grafana.rows.instanceIORow,
                this.grafana.rows.instancePerformanceRow,
                this.grafana.rows.instanceAlertsRow,
                this.grafana.rows.instanceOutliersRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '-instance-overview',
          tags,
          links { sapHanaInstance+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
    } + if this.config.enableLokiLogs then {
      'sap-hana-logs.json':
        logslib.new(
          prefix + ' logs',
          datasourceName=this.grafana.variables.datasources.loki.name,
          datasourceRegex=this.grafana.variables.datasources.loki.regex,
          filterSelector=this.config.filteringSelector,
          labels=this.config.groupLabels + this.config.extraLogLabels,
          formatParser=null,
          showLogsVolume=this.config.showLogsVolume,
        )
        {
          dashboards+:
            {
              logs+:
                root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { sapHanaLogs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
            },
          panels+:
            {
              logs+:
                g.panel.logs.options.withEnableLogDetails(true)
                + g.panel.logs.options.withShowTime(false)
                + g.panel.logs.options.withWrapLogMessage(false),
            },
          variables+: {
            toArray+: [
              this.grafana.variables.datasources.prometheus { hide: 2 },
            ],
          },
        }.dashboards.logs,
    } else {},

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
