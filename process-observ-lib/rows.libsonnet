local g = import './g.libsonnet';

{
  new(panels, type): {

    process: [
      g.panel.row.new('Process'),
      panels.uptime { gridPos: { w: 4, h: 4 } },
      panels.startTime { gridPos: { w: 4, h: 4 } },
      panels.loadAverage { gridPos: { w: 16, h: 4 } },
      panels.cpuUsage { gridPos: { w: 8, h: 6 } },
      panels.filesUsed { gridPos: { w: 8, h: 6 } },
      panels.memoryUsage { gridPos: { w: 8, h: 6 } },
    ],
  },
}
