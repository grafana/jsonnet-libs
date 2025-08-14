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
      'apache-activemq-cluster-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.broker + g.panel.row.withCollapsed(false),
                this.grafana.rows.queues + g.panel.row.withCollapsed(false),
                this.grafana.rows.topics + g.panel.row.withCollapsed(false),
              ],
            ),
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_overview',
          tags,
          links { activemqOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'apache-activemq-queue-overview.json':
        g.dashboard.new(prefix + ' queues')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.queues + g.panel.row.withCollapsed(false),
              ]
            ),
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_queues',
          tags,
          links { activemqQueues+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'apache-activemq-topic-overview.json':
        g.dashboard.new(prefix + ' topics')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.topics + g.panel.row.withCollapsed(false),
              ]
            ),
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_topics',
          tags,
          links { activemqTopics+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

    }
    +
    if this.config.enableLokiLogs then
      {
        'apache-activemq-logs.json':
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
