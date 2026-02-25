local g = import './g.libsonnet';
{
  local root = self,
  new(this):
    {
      'otelcol-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'Collector overview')
        + g.dashboard.withVariables(
          std.map(function(var) var { label: std.strReplace(var.label, '_', ' ') }, this.signals.receiver.getVariablesMultiChoice())
        )
        + g.dashboard.withVariablesMixin([
          {
            datasource: {
              type: 'prometheus',
              uid: '${datasource}',
            },
            baseFilters: [],
            filters: [],
            label: 'Extra filters',
            name: 'adhoc',
            type: 'adhoc',
          },
        ])
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-overview-dashboard')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.overview,
                this.grafana.rows.process,
                this.grafana.rows.receivers,
                this.grafana.rows.processors,
                this.grafana.rows.exporters,
              ]
            )
          ),
          setPanelIDs=false
        ),
    },
}
