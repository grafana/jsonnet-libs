local statusPanels = import '../status-panels/main.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local dashboard = g.dashboard;
local title = 'Status Panel Example';

{
  grafanaDashboards+:: {
    'status-panel-example.json': dashboard.new(title)
                                 + dashboard.withUid(g.util.string.slugify(title))
                                 + dashboard.withPanels(
                                   (statusPanels.new(
                                      'Integration status',
                                      type='metrics',
                                      statusPanelsQueryMetrics='up{job=~"$job"}',
                                      datasourceNameMetrics='$prometheus_datasource',
                                      showIntegrationVersion=true,
                                      integrationVersion='x.x.x',
                                      panelsHeight=2,
                                      panelsWidth=8,
                                      rowPositionY=10,
                                    )).panels.statusPanelsRow
                                 ),
  },
}
