local g = import './g.libsonnet';

{
  new(panels, type): if type == 'otel'
  then {
    golangMemory: [
      g.panel.row.new('Golang runtime: memory'),
      panels.memHeapBytes { gridPos: { w: 12, h: 7 } },
      panels.memHeapObjects { gridPos: { w: 12, h: 7 } },
    ],
    golangRuntime: [
      g.panel.row.new('Golang runtime'),
      panels.uptime { gridPos: { w: 4, h: 7 } },
      panels.cGo { gridPos: { w: 4, h: 7 } },
      panels.goRoutines { gridPos: { w: 8, h: 7 } },
      panels.gcDuration { gridPos: { w: 8, h: 7 } },
    ],

  } else  // prometheus
    {
      golangRuntime: [
        g.panel.row.new('Golang runtime'),
        panels.version { gridPos: { w: 6, h: 4 } },
        panels.uptime { gridPos: { w: 6, h: 4 } },
        panels.cGo { gridPos: { w: 6, h: 4 } },
        panels.goThreads { gridPos: { w: 6, h: 4 } },
        panels.goRoutines { gridPos: { w: 12, h: 7 } },
        panels.gcDuration { gridPos: { w: 12, h: 7 } },
      ],
      golangMemory: [
        g.panel.row.new('Go runtime: memory'),
        panels.mem { gridPos: { w: 8, h: 7 } },
        panels.memHeapBytes { gridPos: { w: 8, h: 7 } },
        panels.memHeapObjects { gridPos: { w: 8, h: 7 } },
        panels.memOffHeap { gridPos: { w: 12, h: 7 } },
        panels.memStack { gridPos: { w: 12, h: 7 } },
      ],
    },
}
