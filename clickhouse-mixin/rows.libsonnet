local g = import './g.libsonnet';
local panels = import './panels.libsonnet';

{
  new(this): {
    replicaOperationsPanels:
      g.panel.row.new('Operations')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.interserverConnectionsPanel { gridPos+: { w: 12 } },
        this.grafana.panels.replicaQueueSizePanel { gridPos+: { w: 12 } },
        this.grafana.panels.replicaOperationsPanel { gridPos+: { w: 12 } },
        this.grafana.panels.replicaReadOnlyPanel { gridPos+: { w: 12 } },
      ]),

    replicaZookeeperPanels:
      g.panel.row.new('ZooKeeper')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.zooKeeperWatchesPanel { gridPos+: { w: 12 } },
        this.grafana.panels.zooKeeperSessionsPanel { gridPos+: { w: 12 } },
        this.grafana.panels.zooKeeperRequestsPanel { gridPos+: { w: 24 } },
      ]),


    overviewQueriesPanels:
      g.panel.row.new('Queries')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.successfulQueriesPanel { gridPos+: { w: 24 } },
        this.grafana.panels.failedQueriesPanel { gridPos+: { w: 12 } },
        this.grafana.panels.rejectedInsertsPanel { gridPos+: { w: 12 } },
      ]),

    overviewMemoryPanels:
      g.panel.row.new('Memory')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.memoryUsagePanel { gridPos+: { w: 12 } },
        this.grafana.panels.memoryUsageGaugePanel { gridPos+: { w: 12 } },
      ]),

    overviewNetworkPanels:
      g.panel.row.new('Network')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.activeConnectionsPanel { gridPos+: { w: 24 } },
        this.grafana.panels.networkReceivedPanel { gridPos+: { w: 12 } },
        this.grafana.panels.networkTransmittedPanel { gridPos+: { w: 12 } },
      ]),

    latencyDiskPanels:
      g.panel.row.new('Disk')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.diskReadLatencyPanel { gridPos+: { w: 12 } },
        this.grafana.panels.diskWriteLatencyPanel { gridPos+: { w: 12 } },
      ]),

    latencyNetworkPanels:
      g.panel.row.new('Network')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.networkTransmitLatencyInboundPanel { gridPos+: { w: 12 } },
        this.grafana.panels.networkTransmitLatencyOutboundPanel { gridPos+: { w: 12 } },
      ]),

    latencyZooKeeperPanels:
      g.panel.row.new('ZooKeeper')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.zooKeeperWaitTimePanel { gridPos+: { w: 24 } },
      ]),
  },
}
