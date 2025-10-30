local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';

{
  local root = self,
  new(this)::
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;

    {
      // SAP HANA system overview dashboard
      'sap-hana-system-overview.json':
        g.dashboard.new(prefix + ' system overview')
        + g.dashboard.withDescription('Dashboard providing an overview of SAP HANA system performance and health.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.systemReplication,
                this.grafana.rows.systemResources,
                this.grafana.rows.systemNetwork,
                this.grafana.rows.systemDisk,
                this.grafana.rows.systemSQL,
                this.grafana.rows.systemConnections,
                this.grafana.rows.systemStorage,
                this.grafana.rows.systemAlerts,
              ]
            )
          )
        )
        + root.applyCommon(
          std.filter(
            function(x) x.name != 'host',
            vars.multiInstance,
          ) + [
            // Add SID variable for SAP HANA system ID
            g.dashboard.variable.query.new('sid')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('sid', 'hanadb_cpu_busy_percent{job=~"$job"}')
            + g.dashboard.variable.query.generalOptions.withLabel('SID')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '_system_overview',
          tags,
          links { sapHanaSystemOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      // SAP HANA instance overview dashboard
      'sap-hana-instance-overview.json':
        g.dashboard.new(prefix + ' instance overview')
        + g.dashboard.withDescription('Dashboard providing detailed overview of SAP HANA instance performance.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.instanceOverview,
                this.grafana.rows.instanceMemory,
                this.grafana.rows.instanceNetwork,
                this.grafana.rows.instanceSQL,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            // Add SID variable
            g.dashboard.variable.query.new('sid')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('sid', 'hanadb_cpu_busy_percent{job=~"$job"}')
            + g.dashboard.variable.query.generalOptions.withLabel('SID')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '_instance_overview',
          tags,
          links { sapHanaInstanceOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
    }
    +
    if this.config.enableLokiLogs then
      {
        'sap-hana-logs.json':
          logslib.new(
            prefix + ' logs',
            datasourceName=this.grafana.variables.datasources.loki.name,
            datasourceRegex=this.grafana.variables.datasources.loki.regex,
            filterSelector=this.config.filteringSelector,
            labels=this.config.logLabels + this.config.extraLogLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
            logsVolumeGroupBy=this.config.logsVolumeGroupBy,
          )
          {
            dashboards+:
              {
                logs+:
                  root.applyCommon(
                    super.logs.templating.list,
                    uid=uid + '_logs',
                    tags=tags,
                    links=links { logs+:: {} },
                    annotations=annotations,
                    timezone=timezone,
                    refresh=refresh,
                    period=period
                  ),
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
                // Add SID variable for logs
                g.dashboard.variable.query.new('sid')
                + g.dashboard.variable.query.withDatasourceFromVariable(this.grafana.variables.datasources.loki)
                + g.dashboard.variable.query.queryTypes.withLabelValues('sid', '{job=~"$job"}')
                + g.dashboard.variable.query.generalOptions.withLabel('SID')
                + g.dashboard.variable.query.selectionOptions.withMulti(true)
                + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
                + g.dashboard.variable.query.refresh.onLoad()
                + g.dashboard.variable.query.refresh.onTime(),
              ],
            },
          }.dashboards.logs,
      }
    else {},

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
