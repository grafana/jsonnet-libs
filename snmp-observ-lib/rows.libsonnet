local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(panels, type):: {
    interface:
      g.panel.row.new('Network interfaces')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.interface.interfacesTable { gridPos+: { w: 24, h: 8 } },
          panels.interface.traffic { gridPos+: { w: 24, h: 8 } },
          panels.interface.errors { gridPos+: { w: 12, h: 6 } },
          panels.interface.dropped { gridPos+: { w: 12, h: 6 } },
          panels.interface.packetsUnicast { gridPos+: { w: 8, h: 8 } },
          panels.interface.packetsBroadcast { gridPos+: { w: 8, h: 8 } },
          panels.interface.packetsMulticast { gridPos+: { w: 8, h: 8 } },
        ]
      ),
    system:
      g.panel.row.new('System')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.system.sysName { gridPos+: { w: 4, h: 3 } },
          panels.system.uptime { gridPos+: { w: 4, h: 3 } },
        ]
      ),
  },
}
