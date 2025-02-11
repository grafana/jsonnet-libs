local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(panels, type):: {
    fleet:
      g.panel.row.new('Fleet overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.fleet.deviceTable { gridPos+: { w: 24, h: 12 } },
          panels.fleet.traffic { gridPos+: { w: 24, h: 8 } },
          panels.fleet.errors { gridPos+: { w: 12, h: 8 } },
          panels.fleet.dropped { gridPos+: { w: 12, h: 8 } },
          panels.fleet.packetsUnicast { gridPos+: { w: 8, h: 8 } },
          panels.fleet.packetsBroadcast { gridPos+: { w: 8, h: 8 } },
          panels.fleet.packetsMulticast { gridPos+: { w: 8, h: 8 } },
        ]
      ),
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
          panels.system.sysName { gridPos+: { w: 3, h: 5 } },
          panels.system.version { gridPos+: { w: 3, h: 5 } },
          panels.system.uptime { gridPos+: { w: 3, h: 5 } },
          panels.cpu.cpuUsage { gridPos+: { w: 7, h: 5 } },
          panels.memory.memoryUsage { gridPos+: { w: 8, h: 5 } },
        ]
      ),
    sensors:
      g.panel.row.new('Sensors')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.temperature.temperature { gridPos+: { w: 12, h: 8 } },
          panels.power.dcVoltage { gridPos+: { w: 12, h: 8 } },
          panels.power.power { gridPos+: { w: 12, h: 8 } },
          panels.power.rxtxPower { gridPos+: { w: 12, h: 8 } },
          panels.fans.fanSpeed { gridPos+: { w: 12, h: 8 } },
        ]
      ),
    fru:
      g.panel.row.new('FRU (Components)')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels(
        [
          panels.system.fruOperStatus { gridPos+: { w: 24, h: 12 } },
        ]
      ),
    fiber:
      g.panel.row.new('Fibre channel')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels(
        [
          panels.fiber.credit { gridPos+: { w: 12, h: 8 } },
          panels.fiber.errors { gridPos+: { w: 12, h: 8 } },
        ]
      ),
  },
}
