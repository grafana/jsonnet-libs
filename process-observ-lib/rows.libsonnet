local g = import './g.libsonnet';

{
  new(panels, type): {

    process:
      g.panel.row.new('Process overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.uptime { gridPos: { w: 8, h: 6 } },
          panels.startTime { gridPos: { w: 8, h: 6 } },
          panels.loadAverage { gridPos: { w: 8, h: 6 } },
          panels.cpuUsage { gridPos: { w: 8, h: 6 } },
          panels.memoryUsage { gridPos: { w: 8, h: 6 } },
          panels.filesUsed { gridPos: { w: 8, h: 6 } },
        ]
      ),
  },
}
