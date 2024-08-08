local g = import './g.libsonnet';
{
  new(this):
    {
      'kafka-topic-dashboard.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'Kafka topic overview')
        + g.dashboard.withVariables(this.signals.consumerGroup.getVariablesMultiChoice())
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-kafka-topic-dashboard')
        + g.dashboard.withLinks(this.grafana.links.otherDashboards)
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.topic,
                this.grafana.rows.consumerGroup,
              ]
            )
          ), setPanelIDs=false
        ),
      'kafka-overview-dashboard.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'Kafka overview')
        + g.dashboard.withVariables(this.signals.broker.getVariablesMultiChoice())
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-kafka-overview-dashboard')
        + g.dashboard.withLinks(this.grafana.links.otherDashboards)
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.overview,
                this.grafana.rows.throughput,
                this.grafana.rows.replication,
                this.grafana.rows.totalTimePerformance,
                this.grafana.rows.messageConversion,
              ]
              + (if this.config.zookeeperEnabled then [this.grafana.rows.zookeeperClient] else [])
              + [
                this.grafana.rows.jvm.process + g.panel.row.withCollapsed(false),
                this.grafana.rows.jvm.overview + g.panel.row.withCollapsed(true),
                this.grafana.rows.jvm.memory + g.panel.row.withCollapsed(true),
                this.grafana.rows.jvm.threads + g.panel.row.withCollapsed(true),
              ]
            )
          ), setPanelIDs=false
        ),
    },
}
