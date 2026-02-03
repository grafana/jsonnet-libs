local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    /*
    -------------------------
    Cluster Overview Rows
    -------------------------
    */

    clusterOverview:
      g.panel.row.new('Cluster overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          // First row within the overview "row" (group) - Stat panels
          panels.clusterClusters { gridPos+: { h: 7, w: 6 } },
          panels.clusterQueueManagers { gridPos+: { h: 7, w: 6 } },
          panels.clusterTopics { gridPos+: { h: 7, w: 6 } },
          panels.clusterQueues { gridPos+: { h: 7, w: 6 } },

          // Second Row within the overview "row" - Cluster status table + pie chart
          panels.clusterStatusTable { gridPos+: { h: 7, w: 16 } },
          panels.clusterQueueOperations { gridPos+: { h: 14, w: 8 } },

          // Third row within the overview "row" - Cluster manager status
          // Note: wraps into 7 by 16 space left over in previous row
          panels.clusterQueueManagerStatusTable { gridPos+: { h: 7, w: 16 } },

          // Fourth row  - No longer need to wrap
          panels.clusterTransmissionQueueTime { gridPos+: { h: 8, w: 24 } },
        ]
      ),

    /*
    -------------------------
    Queue Manager Overview Rows
    -------------------------
    */

    queueManagerOverview:
      g.panel.row.new('Queue manager overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.qmgrActiveListeners { gridPos+: { w: 4 } },
          panels.qmgrActiveConnections { gridPos+: { w: 4 } },
          panels.qmgrQueues { gridPos+: { w: 4 } },
          panels.qmgrEstimatedMemoryUtilization { gridPos+: { w: 12 } },
          panels.qmgrStatusTable { gridPos+: { w: 8 } },
          panels.qmgrCpuUsage { gridPos+: { w: 8 } },
          panels.qmgrDiskUsage { gridPos+: { w: 8 } },
          panels.qmgrCommits { gridPos+: { w: 8 } },
          panels.qmgrPublishThroughput { gridPos+: { w: 8 } },
          panels.qmgrPublishedMessages { gridPos+: { w: 8 } },
          panels.qmgrExpiredMessages { gridPos+: { w: 8 } },
          panels.qmgrQueueOperations { gridPos+: { w: 16 } },
        ]
      ),

    queueManagerLogs:
      g.panel.row.new('Logs')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.qmgrLogLatency { gridPos+: { w: 12 } },
          panels.qmgrLogUsage { gridPos+: { w: 12 } },
        ]
      ),

    /*
    -------------------------
    Queue Overview Rows
    -------------------------
    */

    queueOverview:
      g.panel.row.new('Queue overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.queueAverageQueueTime { gridPos+: { h: 8, w: 12 } },
          panels.queueExpiredMessages { gridPos+: { h: 8, w: 12 } },
          panels.queueDepth { gridPos+: { h: 8, w: 24 } },
          panels.queueOperationThroughput { gridPos+: { h: 8, w: 9 } },
          panels.queueOperations { gridPos+: { h: 8, w: 15 } },
        ]
      ),

    /*
    -------------------------
    Topics Overview Rows
    -------------------------
    */

    topicsRow:
      g.panel.row.new('Topics')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.topicMessagesReceived { gridPos+: { h: 6, w: 16 } },
          panels.topicTimeSinceLastMessage { gridPos+: { h: 6, w: 8 } },
          panels.topicSubscribers { gridPos+: { h: 6, w: 12 } },
          panels.topicPublishers { gridPos+: { h: 6, w: 12 } },
        ]
      ),

    subscriptionsRow:
      g.panel.row.new('Subscriptions')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.subscriptionMessagesReceived { gridPos+: { h: 6, w: 24 } },
          panels.subscriptionStatus { gridPos+: { h: 10, w: 24 } },
        ]
      ),
  },
}
