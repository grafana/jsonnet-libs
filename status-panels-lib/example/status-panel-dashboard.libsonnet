local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local statusPanels = import '../status-panels/main.libsonnet';

local dashboard = g.dashboard;
local title = 'Status Panel Test';

dashboard.new(title)
+ dashboard.withUid(g.util.string.slugify(title))
+ dashboard.withPanels(
  [
    (statusPanels.new(
      'Integration Status',
      statusPanelsQuery="abc",
      datasourceName="DS",
      showIntegrationVersion=true,
    )).rows.statusPanelRow
  ]
)