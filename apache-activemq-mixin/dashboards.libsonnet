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
        g.dashboard.new(prefix + ' cluster overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.clusterOverview + g.panel.row.withCollapsed(false),
              ],
            ),
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_cluster_overview',
          tags,
          links { activemqOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),


      'apache-activemq-instance-overview.json':
        g.dashboard.new(prefix + ' instance overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.instance + g.panel.row.withCollapsed(false),
                this.grafana.rows.instanceJVM + g.panel.row.withCollapsed(false),
              ]
            ),
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_instance_overview',
          tags,
          links { activemqInstanceOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'apache-activemq-queue-overview.json':
        g.dashboard.new(prefix + ' queue overview')
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
          vars.multiInstance + [
            g.dashboard.variable.custom.new(
              'k_selector',
              values=['2', '4', '6', '8', '10'],
            ) + g.dashboard.variable.custom.generalOptions.withCurrent('4')
            + g.dashboard.variable.custom.generalOptions.withLabel('Top queue count')
            + g.dashboard.variable.custom.selectionOptions.withMulti(false)
            + g.dashboard.variable.custom.selectionOptions.withIncludeAll(false),

            g.dashboard.variable.textbox.new('name') + g.dashboard.variable.textbox.generalOptions.withLabel('Queue by name'),
          ],
          uid + '_queues',
          tags,
          links { activemqQueues+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'apache-activemq-topic-overview.json':
        g.dashboard.new(prefix + ' topic overview')
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
          vars.multiInstance + [
            g.dashboard.variable.custom.new(
              'k_selector',
              values=['2', '4', '6', '8', '10'],
            ) + g.dashboard.variable.custom.generalOptions.withCurrent('4')
            + g.dashboard.variable.custom.generalOptions.withLabel('Top topic count')
            + g.dashboard.variable.custom.selectionOptions.withMulti(false)
            + g.dashboard.variable.custom.selectionOptions.withIncludeAll(false),

            // Textbox for topic name
            g.dashboard.variable.textbox.new('name') + g.dashboard.variable.textbox.generalOptions.withLabel('Topic by name'),
          ],
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
