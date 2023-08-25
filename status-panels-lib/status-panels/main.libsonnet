local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  new(
    title,
    statusPanelsQuery,
    datasourceName='datasource',
    showIntegrationVersion=true,
    integrationVersion='0.0.0',
    panelsHeight=2,
    panelsWidth=8,
    rowPositionY=0,
  ): {

    local this = self,

    targets: targets(
      datasourceName,
      statusPanelsQuery,
    ),

    panels: panels(
      title,
      showIntegrationVersion,
      integrationVersion,
      this.targets.statusPanelsTarget,
      panelsHeight,
      panelsWidth,
      rowPositionY=0,
    ),
  },

}
