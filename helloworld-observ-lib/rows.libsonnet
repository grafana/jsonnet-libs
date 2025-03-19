local g = import './g.libsonnet';

// Use g.util.grid.wrapPanels() to import into custom dashboard
{
  new(panels): {
    fleet:
      [
        g.panel.row.new('Row 1'),
        panels.overviewTable1 { gridPos+: { w: 24, h: 16 } },
        panels.timeSeriesPanel1 { gridPos+: { w: 24 } },
        panels.timeSeriesPanel2 { gridPos+: { w: 24 } },
        panels.timeSeriesPanel3 { gridPos+: { w: 12 } },
        panels.timeSeriesPanel1 { gridPos+: { w: 12 } },
        panels.timeSeriesPanel1 { gridPos+: { w: 24 } },
      ],
    overview_1:
      [
        g.panel.row.new('Row 1'),
        panels.statPanel1,
        panels.statPanel1,
        panels.statPanel1,
        panels.statPanel1,
        panels.statPanel1,
        panels.statPanel1,
        panels.statPanel1,
        panels.statPanel1,
      ],
    overview_2:
      [
        g.panel.row.new('Row 2'),
        panels.timeSeriesPanel1 { gridPos+: { w: 6, h: 6 } },
        panels.timeSeriesPanel1 { gridPos+: { w: 18, h: 6 } },
      ],
    overview_3:
      [
        g.panel.row.new('Row 3'),
        panels.timeSeriesPanel2 { gridPos+: { w: 6, h: 6 } },
        panels.timeSeriesPanel2 { gridPos+: { w: 18, h: 6 } },
      ],
    overview_4:
      [
        g.panel.row.new('Row 4'),
        panels.timeSeriesPanel2 { gridPos+: { w: 12, h: 8 } },
        panels.timeSeriesPanel2 { gridPos+: { w: 12, h: 8 } },
      ],
    overview_5:
      [
        g.panel.row.new('Row 5'),
        panels.timeSeriesPanel2 { gridPos+: { w: 12, h: 8 } },
        panels.timeSeriesPanel3 { gridPos+: { w: 12, h: 8 } },
      ],

    dashboard_3_row:
      [
        g.panel.row.new('Dash 3'),
        panels.timeSeriesPanel1,
        panels.timeSeriesPanel1,
        panels.timeSeriesPanel1,
        panels.timeSeriesPanel1,
        panels.timeSeriesPanel1,
        panels.timeSeriesPanel1,
      ],

  },
}
