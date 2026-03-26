local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(panels):: {
    overview:
      g.panel.row.new('Collector overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.fleetOverview { gridPos+: { w: 18 } },
          panels.alertList { gridPos+: { w: 6 } },

          // receivers
          panels.receiverCount { gridPos+: { w: 3, h: 4 } },
          panels.metricsReceiverStat { gridPos+: { w: 4, h: 4 } },
          panels.metricsReceiverSuccessRate { gridPos+: { w: 3, h: 4 } },
          panels.logsReceiverStat { gridPos+: { w: 4, h: 4 } },
          panels.logsReceiverSuccessRate { gridPos+: { w: 3, h: 4 } },
          panels.spansReceiverStat { gridPos+: { w: 4, h: 4 } },
          panels.spansReceiverSuccessRate { gridPos+: { w: 3, h: 4 } },
          // processors
          panels.downArrow { gridPos+: { w: 24, h: 2 } },
          panels.processorCount { gridPos+: { w: 3, h: 6 } },
          panels.metricsByProcessor { gridPos+: { w: 7, h: 6 } },
          panels.logsByProcessor { gridPos+: { w: 7, h: 6 } },
          panels.spansByProcessor { gridPos+: { w: 7, h: 6 } },
          // exporters
          panels.downArrow { gridPos+: { w: 24, h: 2 } },
          panels.exporterCount { gridPos+: { w: 3, h: 4 } },
          panels.metricsExporterStat { gridPos+: { w: 4, h: 4 } },
          panels.metricsExporterSuccessRate { gridPos+: { w: 3, h: 4 } },
          panels.logsExporterStat { gridPos+: { w: 4, h: 4 } },
          panels.logsExporterSuccessRate { gridPos+: { w: 3, h: 4 } },
          panels.spansExporterStat { gridPos+: { w: 4, h: 4 } },
          panels.spansExporterSuccessRate { gridPos+: { w: 3, h: 4 } },
        ]
      ),
    process:
      g.panel.row.new('Process Overview')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels(
        [
          panels.uptime { gridPos+: { w: 12, h: 4 } },
          panels.startTime { gridPos+: { w: 12, h: 4 } },
          panels.cpuUsage { gridPos+: { w: 12 } },
          panels.memoryUsage { gridPos+: { w: 12 } },
        ]
      ),
    receivers:
      g.panel.row.new('Receivers')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.ingestionRate { gridPos+: { w: 24, h: 4 } },
        panels.receiverOverview { gridPos+: { w: 24 } },
      ]),
    processors:
      g.panel.row.new('Processors')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.processingRate { gridPos+: { w: 24, h: 4 } },
        panels.processorOverview { gridPos+: { w: 24 } },
      ]),
    exporters:
      g.panel.row.new('Exporters')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.exportingRate { gridPos+: { w: 24, h: 4 } },
        panels.exporterOverview { gridPos+: { w: 24 } },
        panels.exporterQueueSize { gridPos+: { w: 24 } },
      ]),
  },
}
