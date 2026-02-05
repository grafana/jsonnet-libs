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
      'ibm-mq-cluster-overview.json':
        g.dashboard.new(prefix + ' cluster overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.clusterOverview,
              ]
            ),
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '-cluster-overview',
          tags,
          links { ibmMqClusterOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'ibm-mq-queue-manager-overview.json':
        g.dashboard.new(prefix + ' queue manager overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.queueManagerOverview,
                this.grafana.rows.queueManagerLogs,
              ]
            ),
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '-queue-manager-overview',
          tags,
          links { ibmMqQueueManagerOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'ibm-mq-queue-overview.json':
        g.dashboard.new(prefix + ' queue overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.queueOverview,
              ]
            ),
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('queue')
            + g.dashboard.variable.custom.generalOptions.withLabel('Queue')
            + g.dashboard.variable.custom.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='queue', metric='ibmmq_queue_average_queue_time_seconds')
            + g.dashboard.variable.query.withDatasourceFromVariable(variable=vars.datasources.prometheus)
            + g.dashboard.variable.custom.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '-queue-overview',
          tags,
          links { ibmMqQueueOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'ibm-mq-topics-overview.json':
        g.dashboard.new(prefix + ' topics overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.topicsRow,
                this.grafana.rows.subscriptionsRow,
              ]
            ),
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('topic')
            + g.dashboard.variable.custom.generalOptions.withLabel('Topic')
            + g.dashboard.variable.custom.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='topic', metric='ibmmq_topic_subscriber_count{qmgr=~"$qmgr",topic!~"SYSTEM.*|\\\\$SYS.*|"}')
            + g.dashboard.variable.query.withDatasourceFromVariable(variable=vars.datasources.prometheus)
            + g.dashboard.variable.custom.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onTime(),

            g.dashboard.variable.query.new('subscription')
            + g.dashboard.variable.custom.generalOptions.withLabel('Subscription')
            + g.dashboard.variable.custom.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='subscription', metric='ibmmq_subscription_messsages_received{qmgr=~"$qmgr",subscription!~"SYSTEM.*|"}')
            + g.dashboard.variable.query.withDatasourceFromVariable(variable=vars.datasources.prometheus)
            + g.dashboard.variable.custom.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '-topics-overview',
          tags,
          links { ibmMqTopicsOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
    }
    + if this.config.enableLokiLogs then {
      'ibm-mq-logs.json':
        logslib.new(
          prefix + ' logs',
          datasourceName=this.grafana.variables.datasources.loki.name,
          datasourceRegex=this.grafana.variables.datasources.loki.regex,
          filterSelector=this.config.filteringSelector,
          labels=this.config.groupLabels + this.config.extraLogLabels + ['qmgr'],
          formatParser=null,
          showLogsVolume=this.config.showLogsVolume,
        )
        {
          dashboards+:
            {
              logs+:
                root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
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
