local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  local root = self,
  new(this): {
    local prefix = this.config.dashboardNamePrefix,
    local links = this.grafana.links,
    local tags = this.config.dashboardTags,
    local uid = this.config.uid,
    local vars = this.grafana.variables,
    local annotations = this.grafana.annotations,
    local refresh = this.config.dashboardRefresh,
    local period = this.config.dashboardPeriod,
    local timezone = this.config.dashboardTimezone,
    local rows = this.grafana.rows,

    clusterOverview:
      g.dashboard.new(prefix + ' - cluster overview')
      + g.dashboard.withPanels(
        g.util.grid.wrapPanels(
          [
            rows.clusterOverviewStats,
            rows.clusterStatus,
            rows.clusterChannels,
          ], panelHeight=1, startY=0
        )
      )
      + root.applyCommon(
        vars.multiInstance,
        uid + '-cluster-overview',
        tags,
        links,
        annotations,
        timezone,
        refresh,
        period
      ),

    queueManagerOverview:
      g.dashboard.new(prefix + ' - queue manager overview')
      + g.dashboard.withPanels(
        g.util.grid.wrapPanels(
          [
            rows.queueManagerOverviewStats,
            rows.queueManagerStatus,
            rows.queueManagerPerformance,
            rows.queueManagerLogs,
          ], panelHeight=1, startY=0
        )
      )
      + root.applyCommon(
        vars.multiInstance,
        uid + '-queue-manager-overview',
        tags,
        links,
        annotations,
        timezone,
        refresh,
        period
      ),

    queueOverview:
      local queueVar = g.dashboard.variable.query.new('queue')
                       + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
                       + g.dashboard.variable.query.queryTypes.withLabelValues('queue', 'ibmmq_queue_depth{%(filteringSelector)s,queue!~"SYSTEM.*|AMQ.*"}' % this.config)
                       + g.dashboard.variable.query.withRegex('')
                       + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
                       + g.dashboard.variable.query.generalOptions.withLabel('Queue')
                       + g.dashboard.variable.query.refresh.onTime()
                       + g.dashboard.variable.query.withSort(type='alphabetical');
      g.dashboard.new(prefix + ' - queue overview')
      + g.dashboard.withPanels(
        g.util.grid.wrapPanels(
          [
            rows.queueMetrics,
          ], panelHeight=1, startY=0
        )
      )
      + root.applyCommon(
        vars.multiInstance + [queueVar],
        uid + '-queue-overview',
        tags,
        links,
        annotations,
        timezone,
        refresh,
        period
      ),

    topicsOverview:
      local topicVar = g.dashboard.variable.query.new('topic')
                       + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
                       + g.dashboard.variable.query.queryTypes.withLabelValues('topic', 'ibmmq_topic_subscriber_count{%(filteringSelector)s,topic!~"SYSTEM.*|\\\\$SYS.*|"}' % this.config)
                       + g.dashboard.variable.query.withRegex('')
                       + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
                       + g.dashboard.variable.query.generalOptions.withLabel('Topic')
                       + g.dashboard.variable.query.refresh.onTime()
                       + g.dashboard.variable.query.withSort(type='alphabetical');
      local subscriptionVar = g.dashboard.variable.query.new('subscription')
                              + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
                              + g.dashboard.variable.query.queryTypes.withLabelValues('subscription', 'ibmmq_subscription_messsages_received{%(filteringSelector)s,subscription!~"SYSTEM.*|"}' % this.config)
                              + g.dashboard.variable.query.withRegex('')
                              + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
                              + g.dashboard.variable.query.generalOptions.withLabel('Subscription')
                              + g.dashboard.variable.query.refresh.onTime()
                              + g.dashboard.variable.query.withSort(type='alphabetical');
      g.dashboard.new(prefix + ' - topics overview')
      + g.dashboard.withPanels(
        g.util.grid.wrapPanels(
          [
            rows.topics,
            rows.subscriptions,
          ], panelHeight=1, startY=0
        )
      )
      + root.applyCommon(
        vars.multiInstance + [topicVar, subscriptionVar],
        uid + '-topics-overview',
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
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),
}
