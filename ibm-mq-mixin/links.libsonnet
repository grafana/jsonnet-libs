local g = import './g.libsonnet';

{
  new(this)::
    {
      local link = g.dashboard.link,


      ibmMqClusterOverview:
        g.dashboard.link.link.new('IBM MQ cluster overview', '/d/' + this.grafana.dashboards['ibm-mq-cluster-overview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true)
        + g.dashboard.link.link.options.withIncludeVars(true),

      ibmMqQueueManagerOverview:
        g.dashboard.link.link.new('IBM MQ queue manager overview', '/d/' + this.grafana.dashboards['ibm-mq-queue-manager-overview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true)
        + g.dashboard.link.link.options.withIncludeVars(true),

      ibmMqQueueOverview:
        g.dashboard.link.link.new('IBM MQ queue overview', '/d/' + this.grafana.dashboards['ibm-mq-queue-overview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true)
        + g.dashboard.link.link.options.withIncludeVars(true),

      ibmMqTopicsOverview:
        g.dashboard.link.link.new('IBM MQ topics overview', '/d/' + this.grafana.dashboards['ibm-mq-topics-overview.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true)
        + g.dashboard.link.link.options.withIncludeVars(true),

      otherDashboards:
        link.dashboards.new('All dashboards', this.config.dashboardTags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),

    } + if this.config.enableLokiLogs then {
      ibmMqLogs:
        g.dashboard.link.link.new('IBM MQ logs', '/d/' + this.grafana.dashboards['ibm-mq-logs.json'].uid)
        + g.dashboard.link.link.options.withKeepTime(true)
        + g.dashboard.link.link.options.withIncludeVars(true),
    } else {},
}
