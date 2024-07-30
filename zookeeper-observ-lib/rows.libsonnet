local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(panels, type):: {
    overview:
      g.panel.row.new('Zookeeper overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.zookeeper.quorumSize { gridPos+: { w: 4, h: 4 } },
          panels.zookeeper.aliveConnections { gridPos+: { w: 4, h: 4 } },
          panels.zookeeper.outstandingRequests { gridPos+: { w: 16, h: 8 } },
          panels.zookeeper.znodes { gridPos+: { w: 4, h: 4 } },
          panels.zookeeper.watchers { gridPos+: { w: 4, h: 4 } },
        ]
      ),

    latency:
      g.panel.row.new('Latency')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.latency.minLatency { gridPos+: { w: 8, h: 6 } },
          panels.latency.avgLatency { gridPos+: { w: 8, h: 6 } },
          panels.latency.maxLatency { gridPos+: { w: 8, h: 6 } },
        ]
      ),

  },
}
