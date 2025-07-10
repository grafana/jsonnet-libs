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
    local rows = this.grafana.rows;

    {
      'clickhouse-replica.json':
        g.dashboard.new(prefix + ' replica')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [rows.replicaOperationsPanels, rows.replicaZookeeperPanels]
            )
          )
        )
        + root.applyCommon(
          vars.singleInstance,
          uid + '_replica',
          tags,
          links { clickhouseReplica+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'clickhouse-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [rows.overviewQueriesPanels, rows.overviewMemoryPanels, rows.overviewNetworkPanels]
            )
          )
        )
        + root.applyCommon(
          vars.singleInstance,
          uid + '_overview',
          tags,
          links { clickhouseOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'clickhouse-latency.json':
        g.dashboard.new(prefix + ' latency')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [rows.latencyDiskPanels, rows.latencyNetworkPanels, rows.latencyZooKeeperPanels]
            )
          )
        )
        + root.applyCommon(
          vars.singleInstance,
          uid + '_latency',
          tags,
          links { clickhouseLatency+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

    }
    +
    if this.config.enableLokiLogs then
      {
        'logs.json':
          logslib.new(
            prefix + ' logs',
            datasourceName=this.grafana.variables.datasources.loki.name,
            datasourceRegex=this.grafana.variables.datasources.loki.regex,
            filterSelector=this.config.filteringSelector,
            labels=this.config.logLabels + this.config.extraLogLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
          )
          {
            dashboards+:
              {
                logs+:
                  // reference to self, already generated variables, to keep them, but apply other common data in applyCommon
                  root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { logs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
              },
            panels+:
              {
                logs+:
                  g.panel.logs.options.withEnableLogDetails(true)
                  + g.panel.logs.options.withShowTime(false)
                  + g.panel.logs.options.withWrapLogMessage(false),
              },
            variables+: {
              // add prometheus datasource for annotations processing
              toArray+: [
                this.grafana.variables.datasources.prometheus { hide: 2 },
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
