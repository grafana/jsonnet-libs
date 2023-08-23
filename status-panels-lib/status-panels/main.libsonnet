local rows = import './rows.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  new(
    title,
    statusPanelsQuery,
    datasourceName='datasource',
    showIntegrationVersion=true,
  ): {

    local this = self,

    targets: targets(
      datasourceName,
      statusPanelsQuery,
    ),

    panels: panels(
      this.targets.statusPanelsTarget,
    ),

    rows: rows(
      title,
      this.panels,
    ),
  },

}
