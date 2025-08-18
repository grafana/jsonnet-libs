local g = import './g.libsonnet';

// Use g.util.grid.wrapPanels() to import into custom dashboard
{
  new(this): {
    // Cluster overview
    clusterOverview:
      g.panel.row.new('Cluster Overview')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.clustersCountPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.brokerCountPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.producersCountPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.consumersCountPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.enqueueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.dequeueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.averageTemporaryMemoryUsagePanel + g.panel.stat.gridPos.withW(8),
          this.grafana.panels.averageStoreMemoryUsagePanel + g.panel.stat.gridPos.withW(8),
          this.grafana.panels.averageBrokerMemoryUsagePanel + g.panel.stat.gridPos.withW(8),
        ]
      ),

    // Broker overview
    broker:
      g.panel.row.new('Broker Overview')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.brokersOnlinePanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.memoryUsagePanel + g.panel.gauge.gridPos.withW(6),
          this.grafana.panels.storeUsagePanel + g.panel.gauge.gridPos.withW(6),
          this.grafana.panels.tempUsagePanel + g.panel.gauge.gridPos.withW(6),
        ]
      ),

    // Queue metrics
    queues:
      g.panel.row.new('Queues')
      + g.panel.row.withPanels(
        [
          this.grafana.panels.queueCountPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.totalQueueSizePanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.queueProducersPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.queueConsumersPanel + g.panel.stat.gridPos.withW(6),
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
          this.grafana.panels.topicCountPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.topicProducersPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.topicConsumersPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.topicAverageConsumersPanel + g.panel.stat.gridPos.withW(6),
          this.grafana.panels.topicEnqueueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.topicDequeueRatePanel + g.panel.timeSeries.gridPos.withW(12),
          this.grafana.panels.topicAverageEnqueueTimePanel + g.panel.timeSeries.gridPos.withW(8),
          this.grafana.panels.topicExpiredRatePanel + g.panel.timeSeries.gridPos.withW(8),
          this.grafana.panels.topicAverageMessageSizePanel + g.panel.timeSeries.gridPos.withW(8),
          this.grafana.panels.topicSummaryPanel + g.panel.table.gridPos.withW(24),
        ]
      ),
  },
}
