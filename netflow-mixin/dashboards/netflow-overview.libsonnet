local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;

local panels = import 'panels.libsonnet';


local labelVar = function(label, title=label) var.query.new(label, 'network_io_bytes')
                                              + var.query.refresh.onTime()
                                              + var.query.generalOptions.withLabel(title)
                                              + var.query.queryTypes.withLabelValues(
                                                label,
                                              )
                                              + var.query.withDatasource(
                                                type='prometheus',
                                                uid='$prometheus_datasource',
                                              )
                                              + var.query.selectionOptions.withMulti()
                                              + var.query.selectionOptions.withIncludeAll(customAllValue='.+');
local withPos(x, y, h, w) = { gridPos+: { x: x, y: y, h: h, w: w } };

local dashboardUid = 'netflow-overview';

{
  grafanaDashboards+:: {
    'netflow-overview.json':
      g.dashboard.new('Netflow overview')
      + g.dashboard.withUid(dashboardUid)
      + g.dashboard.withTags($._config.dashboardTags)
      + g.dashboard.time.withFrom($._config.dashboardPeriod)
      + g.dashboard.withRefresh($._config.dashboardRefresh)
      + g.dashboard.withTimezone($._config.dashboardTimezone)
      + g.dashboard.withVariables([
        var.datasource.new('prometheus_datasource', 'prometheus')
        + var.query.generalOptions.withLabel('Prometheus data source'),
        var.datasource.new('loki_datasource', 'loki')
        + var.query.generalOptions.withLabel('Loki data source'),
        labelVar('job', 'Job')
        + var.query.generalOptions.showOnDashboard.withNothing(),
        labelVar('device_name', 'Device name'),
        labelVar('network_local_address', 'Source'),
        labelVar('network_peer_address', 'Destination'),
      ])
      + g.dashboard.withPanels([
        panels.totalTraffic
        + withPos(0, 1, 5, 15),
        panels.stats
        + withPos(15, 1, 5, 9),
        panels.topSources
        + withPos(0, 6, 8, 12),
        panels.topDestinations
        + withPos(12, 6, 8, 12),
        g.panel.row.new('Conversations')
        + withPos(0, 14, 1, 24),
        panels.conversationTotalBytes
        + withPos(0, 15, 15, 15),
        panels.conversationTraffic
        + withPos(15, 15, 7, 9),
        panels.conversationByPair
        + withPos(15, 22, 8, 9),
        g.panel.row.new('Protocols')
        + withPos(0, 30, 1, 24),
        panels.protocolTotalBytes
        + withPos(0, 31, 15, 15),
        panels.protocolDistribution
        + withPos(15, 31, 7, 9),
        panels.protocolOverTime
        + withPos(15, 38, 8, 9),
        g.panel.row.new('Geographic data')
        + withPos(0, 46, 1, 24),
        panels.topDestinationMap
        + withPos(0, 47, 13, 8),
        panels.destinationsLegend
        + withPos(8, 47, 13, 4),
        panels.topSourcesMap
        + withPos(12, 47, 13, 8),
        panels.sourcesLegend
        + withPos(20, 47, 13, 4),
        g.panel.row.new('Collector details')
        + withPos(0, 60, 1, 24),
        panels.collectorLogs
        + withPos(0, 61, 8, 17),
        panels.deviceStats
        + withPos(17, 61, 8, 7),
      ]),

  },
}
