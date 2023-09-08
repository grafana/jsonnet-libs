local dashboards = import './dashboards.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';
local g = import './g.libsonnet';

{
  new(
    title,
    filterSelector,
    labels,
    datasourceRegex,
    datasourceName='datasource',
    formatParser=null,
    showLogsVolume=true,
    logsVolumeGroupBy='level',
    extraFilters='',
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
      logsVolumeGroupBy,
      extraFilters,
    ),

    panels: panels(
      this.targets.logsVolumeTarget,
      this.targets.logsTarget,
    ),

    dashboards: dashboards(
      title,
      showLogsVolume,
      this.panels,
      this.variables,
    ),
  },

}
