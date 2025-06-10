local g = import './g.libsonnet';

// Use g.util.grid.wrapPanels() to import into custom dashboard
{
  new(panels): {
    row_1:
      [
        g.panel.row.new('Row 1'),
        panels.interserverConnectionsPanel { gridPos+: { h: 8, w: 12, x: 0, y: 0 } },
        panels.replicaQueueSizePanel { gridPos+: { h: 8, w: 12, x: 12, y: 0 } },
      ],

    row_2:
      [
        g.panel.row.new('Row 2'),
        panels.replicaOperationsPanel { gridPos+: { h: 8, w: 12, x: 0, y: 8 } },
        panels.replicaReadOnlyPanel { gridPos+: { h: 8, w: 12, x: 12, y: 8 } },
      ],

    row_3:
      [
        g.panel.row.new('Row 3'),
        panels.zooKeeperWatchesPanel { gridPos+: { h: 8, w: 12, x: 0, y: 16 } },
        panels.zooKeeperSessionsPanel { gridPos+: { h: 8, w: 12, x: 12, y: 16 } },
      ],

    row_4:
      [
        g.panel.row.new('Row 4'),
        panels.zooKeeperRequestsPanel { gridPos+: { h: 8, w: 24, x: 0, y: 24 } },
      ],

    row_5:
      [
        g.panel.row.new('Row 5'),
        panels.successfulQueriesPanel { gridPos+: { h: 8, w: 24, x: 0, y: 0 } },
      ],

    row_6:
      [
        g.panel.row.new('Row 6'),
        panels.failedQueriesPanel { gridPos+: { h: 8, w: 12, x: 0, y: 8 } },
        panels.rejectedInsertsPanel { gridPos+: { h: 8, w: 12, x: 12, y: 8 } },
      ],

    row_7:
      [
        g.panel.row.new('Row 7'),
        panels.memoryUsagePanel { gridPos+: { h: 8, w: 12, x: 0, y: 16 } },
        panels.memoryUsageGaugePanel { gridPos+: { h: 8, w: 12, x: 12, y: 16 } },
      ],

    row_8:
      [
        g.panel.row.new('Row 8'),
        panels.activeConnectionsPanel { gridPos+: { h: 8, w: 24, x: 0, y: 24 } },
      ],

    row_9:
      [
        g.panel.row.new('Row 9'),
        panels.networkReceivedPanel { gridPos+: { h: 8, w: 12, x: 0, y: 32 } },
        panels.networkTransmittedPanel { gridPos+: { h: 8, w: 12, x: 12, y: 32 } },
      ],

    row_10:
      [
        g.panel.row.new('Row 10'),
        panels.diskReadLatencyPanel { gridPos+: { h: 8, w: 12, x: 0, y: 0 } },
        panels.diskWriteLatencyPanel { gridPos+: { h: 8, w: 12, x: 12, y: 0 } },
      ],

    row_11:
      [
        g.panel.row.new('Row 11'),
        panels.networkTransmitLatencyInboundPanel { gridPos+: { h: 8, w: 12, x: 0, y: 8 } },
        panels.networkTransmitLatencyOutboundPanel { gridPos+: { h: 8, w: 12, x: 12, y: 8 } },
      ],

    row_12:
      [
        g.panel.row.new('Row 12'),
        panels.zooKeeperWaitTimePanel { gridPos+: { h: 8, w: 24, x: 0, y: 16 } },
      ],

  },
}
