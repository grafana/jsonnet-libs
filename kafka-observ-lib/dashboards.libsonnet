local g = import './g.libsonnet';
{
  new(this):
    {
      'kafka-topic-dashboard.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'Kafka topic overview')
        + g.dashboard.withVariables(this.signals.consumerGroup.getVariablesMultiChoice())
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-topic-dashboard')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            std.flattenArrays([
              this.grafana.rows.topic,
              this.grafana.rows.consumerGroup,
            ])
          ), setPanelIDs=false
        ),
    },
}
