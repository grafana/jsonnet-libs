local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    // Cluster overview rows
    clusterOverviewStats:
      g.panel.row.new('Cluster overview')
      + g.panel.row.withPanels([
        panels.clusterCount + g.panel.stat.gridPos.withW(4) + g.panel.stat.gridPos.withH(7),
        panels.queueManagerCount + g.panel.stat.gridPos.withW(4) + g.panel.stat.gridPos.withH(7),
        panels.topicCount + g.panel.stat.gridPos.withW(4) + g.panel.stat.gridPos.withH(7),
        panels.queueCount + g.panel.stat.gridPos.withW(4) + g.panel.stat.gridPos.withH(7),
        panels.clusterQueueOperations + g.panel.pieChart.gridPos.withW(8) + g.panel.pieChart.gridPos.withH(15),
      ]),

    clusterStatus:
      g.panel.row.new('Status')
      + g.panel.row.withPanels([
        panels.clusterStatus + g.panel.table.gridPos.withW(16) + g.panel.table.gridPos.withH(4),
        panels.queueManagerStatus + g.panel.table.gridPos.withW(16) + g.panel.table.gridPos.withH(4),
      ]),

    clusterChannels:
      g.panel.row.new('Channels')
      + g.panel.row.withPanels([
        panels.transmissionQueueTime + g.panel.timeSeries.gridPos.withW(24) + g.panel.timeSeries.gridPos.withH(8),
      ]),

    // Queue manager overview rows
    queueManagerOverviewStats:
      g.panel.row.new('Overview')
      + g.panel.row.withPanels([
        panels.activeListeners + g.panel.stat.gridPos.withW(4) + g.panel.stat.gridPos.withH(7),
        panels.activeConnections + g.panel.stat.gridPos.withW(4) + g.panel.stat.gridPos.withH(7),
        panels.queuesManaged + g.panel.stat.gridPos.withW(4) + g.panel.stat.gridPos.withH(7),
        panels.memoryUtilization + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(7),
      ]),

    queueManagerStatus:
      g.panel.row.new('Status')
      + g.panel.row.withPanels([
        panels.queueManagerStatus + g.panel.table.gridPos.withW(8) + g.panel.table.gridPos.withH(7),
        panels.cpuUsage + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(7),
        panels.diskUsage + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(7),
      ]),

    queueManagerPerformance:
      g.panel.row.new('Performance')
      + g.panel.row.withPanels([
        panels.freeDiskSpace + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
        panels.commitRate + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
        panels.publishedBytes + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(8),
        panels.publishedMessages + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(8),
        panels.expiredMessages + g.panel.timeSeries.gridPos.withW(8) + g.panel.timeSeries.gridPos.withH(8),
      ]),

    queueManagerLogs:
      g.panel.row.new('Logs')
      + g.panel.row.withPanels([
        panels.logWriteLatency + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
        panels.logUsage + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
      ]),

    // Queue overview rows
    queueMetrics:
      g.panel.row.new('Queue metrics')
      + g.panel.row.withPanels([
        panels.queueAverageTime + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
        panels.queueExpiredMessages + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(8),
        panels.queueDepth + g.panel.timeSeries.gridPos.withW(24) + g.panel.timeSeries.gridPos.withH(8),
        panels.queueOperationThroughput + g.panel.timeSeries.gridPos.withW(9) + g.panel.timeSeries.gridPos.withH(8),
        panels.queueOperations + g.panel.timeSeries.gridPos.withW(15) + g.panel.timeSeries.gridPos.withH(8),
      ]),

    // Topics overview rows
    topics:
      g.panel.row.new('Topics')
      + g.panel.row.withPanels([
        panels.topicMessagesReceived + g.panel.timeSeries.gridPos.withW(16) + g.panel.timeSeries.gridPos.withH(6),
        panels.timeSinceLastMessage + g.panel.barGauge.gridPos.withW(8) + g.panel.barGauge.gridPos.withH(6),
        panels.topicSubscribers + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(6),
        panels.topicPublishers + g.panel.timeSeries.gridPos.withW(12) + g.panel.timeSeries.gridPos.withH(6),
      ]),

    subscriptions:
      g.panel.row.new('Subscriptions')
      + g.panel.row.withPanels([
        panels.subscriptionMessagesReceived + g.panel.timeSeries.gridPos.withW(24) + g.panel.timeSeries.gridPos.withH(6),
        panels.subscriptionStatus + g.panel.table.gridPos.withW(24) + g.panel.table.gridPos.withH(10),
      ]),
  },
}
