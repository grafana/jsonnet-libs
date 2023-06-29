local dashboards = import './dashboards.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  new(
    title,
    filterSelector,
    labels,
    datasourceRegex,
    datasourceName='datasource',
    formatParser=null,
    showLogsVolume=true,
  ): {

    local this = self,
    variables: variables(
      datasourceName,
      datasourceRegex,
      filterSelector,
      labels,
    ),

    targets: targets(
      this.variables,
      formatParser,
    ),

    panels: panels(
      this.targets.logsVolumeTarget,
      this.targets.logsTarget
    ),

    dashboards: dashboards(
      title,
      showLogsVolume,
      this.panels,
      this.variables,
    ),
  },

}
