local g = import './g.libsonnet';

// Use g.util.grid.wrapPanels() to import into custom dashboard
{
  new(this): {
    // Cluster overview
    clusterOverview:
      g.panel.row.new('Cluster Overview')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.clustersCountPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.brokerCountPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.producersCountPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.consumersCountPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.enqueueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.dequeueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.averageTemporaryMemoryUsagePanel + g.panel.stat.gridPos.withW(8),
          this.grafana.panels.averageStoreMemoryUsagePanel + g.panel.stat.gridPos.withW(8),
          this.grafana.panels.averageBrokerMemoryUsagePanel + g.panel.stat.gridPos.withW(8),
        ]
      ),

    instance:
      g.panel.row.new('Instance')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.instanceBrokerMemoryUsagePanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.instanceAverageStoreUsagePanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.instanceAverageBrokerMemoryUsagePanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.instanceAverageTemporaryMemoryUsagePanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.activeMQAlertsPanel + g.panel.stat.gridPos.withW(12),
          this.grafana.panels.producerCountPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.consumerCountPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.queueSizePanel + g.panel.stat.gridPos.withW(12),
          this.grafana.panels.destinationMemoryUsagePanel + g.panel.stat.gridPos.withW(12),
          this.grafana.panels.enqueueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.dequeueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.averageEnqueueTimePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.expiredMessagesPanel + g.panel.timeSeries.gridPos.withW(12),
        ]
      ),

    instanceJVM:
      g.panel.row.new('JVM resources')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.garbageCollectionDurationPanel + g.panel.stat.gridPos.withW(12),
          this.grafana.panels.garbageCollectionCountPanel + g.panel.stat.gridPos.withW(12),
        ]
      ),

    // Queue metrics
    queues:
      g.panel.row.new('Queues')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.queueCountPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.totalQueueSizePanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.queueProducersPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.queueConsumersPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.queueEnqueueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.queueDequeueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.queueAverageEnqueueTimePanel + g.panel.timeSeries.gridPos.withW(8),
          this.grafana.panels.queueExpiredRatePanel + g.panel.timeSeries.gridPos.withW(8),
          this.grafana.panels.queueAverageMessageSizePanel + g.panel.timeSeries.gridPos.withW(8),
          this.grafana.panels.queueSummaryPanel + g.panel.table.gridPos.withW(24),
        ]
      ),

    // Topic metrics
    topics:
      g.panel.row.new('Topics')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.topicCountPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.topicProducersPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.topicConsumersPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.topicAverageConsumersPanel + g.panel.stat.gridPos.withW(6) + g.panel.stat.gridPos.withH(6),
          this.grafana.panels.topicEnqueueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.topicDequeueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.topicAverageEnqueueTimePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.topicExpiredRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.topicTopicsByConsumers + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.topicAverageMessageSizePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.topicSummaryPanel + g.panel.table.gridPos.withW(24),
        ]
      ),
  },
}
