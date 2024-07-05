local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(panels, type):: {
    overview: [
      g.panel.row.new('JVM overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.memoryUsedHeapPercent { gridPos+: { w: 4, h: 4 } },
          panels.memoryUsedNonHeapPercent { gridPos+: { w: 4, h: 4 } },
          panels.threadsOverviewStat { gridPos+: { w: 4, h: 4 } },
          panels.classesLoaded { gridPos+: { w: 4, h: 4 } },
        ]
      ),
    ],
    gc: [
      g.panel.row.new('JVM garbage collection')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.memoryUsedEden,
          panels.memoryUsedSurvival,
          panels.memoryUsedTenured,
          panels.gc,
          panels.gcDuration,
          panels.promotedAllocated,
        ]
      ),
    ],
    memory: [
      g.panel.row.new('JVM memory')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.memoryUsedHeap { w: 12, h: 6 },
          panels.memoryUsedNonHeap { w: 12, h: 6 },
        ]
      ),
    ],
    threads: [
      g.panel.row.new('JVM threads')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.threadsOverviewTS,
          panels.threadStates,
        ]
      ),
    ],
    buffers: [
      g.panel.row.new('JVM buffers')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.directBuffer,
          panels.mappedBuffer,
        ]
      ),
    ],
    hikari: [
      g.panel.row.new('Hikari pools')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels(
        [
          panels.hikariConnections { gridPos+: { w: 4, h: 6 } },
          panels.hikariTimeouts { gridPos+: { w: 4, h: 6 } },
          panels.hikariConnectionsStates { gridPos+: { w: 16, h: 6 } },
          panels.hikariConnectionsCreate { gridPos+: { w: 8, h: 6 } },
          panels.hikariConnectionsUsage { gridPos+: { w: 8, h: 6 } },
          panels.hikariConnectionsAcquire { gridPos+: { w: 8, h: 6 } },
        ]
      ),
    ],
    logback: [
      g.panel.row.new('Logback')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels(
        [
          panels.logs { gridPos+: { w: 24, h: 6 } },
        ],
      ),
    ],
  },
}
