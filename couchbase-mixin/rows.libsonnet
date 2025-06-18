local g = import './g.libsonnet';

// Use g.util.grid.wrapPanels() to import into custom dashboard
{
  new(panels): {
    row_1:
      [
        g.panel.row.new('Row 1'),
        panels.memoryUtilizationPanel { gridPos+: { h: 8, w: 12, x: 0, y: 0 } },
        panels.cpuUtilizationPanel { gridPos+: { h: 8, w: 12, x: 12, y: 0 } },
      ],

    row_2:
      [
        g.panel.row.new('Row 2'),
        panels.totalMemoryUsedByServicePanel { gridPos+: { h: 8, w: 8, x: 0, y: 8 } },
        panels.backupSizePanel { gridPos+: { h: 8, w: 8, x: 8, y: 8 } },
        panels.currentConnectionsPanel { gridPos+: { h: 8, w: 8, x: 16, y: 8 } },
      ],

    row_3:
      [
        g.panel.row.new('Row 3'),
        panels.httpResponseCodesPanel { gridPos+: { h: 8, w: 12, x: 0, y: 16 } },
        panels.httpRequestMethodsPanel { gridPos+: { h: 8, w: 12, x: 12, y: 16 } },
      ],

    row_4:
      [
        g.panel.row.new('Row 4'),
        panels.queryServiceRequestsPanel { gridPos+: { h: 8, w: 12, x: 0, y: 24 } },
        panels.queryServiceRequestProcessingTimePanel { gridPos+: { h: 8, w: 12, x: 12, y: 24 } },
      ],

    row_5:
      [
        g.panel.row.new('Row 5'),
        panels.indexServiceRequestsPanel { gridPos+: { h: 8, w: 8, x: 0, y: 32 } },
        panels.indexCacheHitRatioPanel { gridPos+: { h: 8, w: 8, x: 8, y: 32 } },
        panels.averageScanLatencyPanel { gridPos+: { h: 8, w: 8, x: 16, y: 32 } },
      ],

    row_6:
      [
        g.panel.row.new('Row 6'),
        panels.errorLogsPanel { gridPos+: { h: 7, w: 24, x: 0, y: 40 } },
      ],

    row_7:
      [
        g.panel.row.new('Row 7'),
        panels.couchbaseLogsPanel { gridPos+: { h: 8, w: 24, x: 0, y: 47 } },
      ],

  },
}
