local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
{

  new(this):

    {
      _common::
        g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withTimezone(this.config.dashboardTimezone)
        + g.dashboard.withRefresh(this.config.dashboardRefresh)
        + g.dashboard.timepicker.withTimeOptions(this.config.dashboardPeriod)
        + g.dashboard.withLinks(std.objectValues(this.grafana.links)),
    }
    +
    {

      'docker.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'Docker overview')
        + g.dashboard.withUid(this.config.uid + '-overview')
        + self._common
        + g.dashboard.withVariables(
          //combine single choice 'instance' with multichoice 'name'
          std.setUnion(
            this.signals.machine.getVariablesSingleChoice(),
            this.signals.container.getVariablesMultiChoice(),
            keyF=function(x) x.name
          )
        )
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            this.grafana.rows.overview
            + this.grafana.rows.compute
            + this.grafana.rows.network
            + this.grafana.rows.disks
          )
        ),
    }
    +
    (if this.config.enableLokiLogs then
       {
         'docker-logs.json':
           logslib.new(
             this.config.dashboardNamePrefix + 'Docker logs',
             datasourceName='loki_datasource',
             datasourceRegex='',
             filterSelector=this.config.logsFilteringSelector,
             labels=this.config.logsLabels,
             formatParser=this.config.logsFormatParser,
             showLogsVolume=this.config.showLogsVolume,
             logsVolumeGroupBy=this.config.logsVolumeGroupBy,
             extraFilters=this.config.logsExtraFilters
           ).dashboards.logs
           + self._common
           + g.dashboard.withUid(this.config.uid + '-logs'),
       } else {}),
}
