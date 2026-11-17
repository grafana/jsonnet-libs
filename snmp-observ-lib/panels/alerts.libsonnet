local g = import '../g.libsonnet';
local alertsOverviewlib = import 'alerts-observ-lib/main.libsonnet';
{
  new(signals, this):: {
    local alertsOverview =
      alertsOverviewlib.new()
      + alertsOverviewlib.withConfigMixin({
        filteringSelector: this.config.filteringSelector,
        groupLabels: this.config.groupLabels,
        instanceLabels: this.config.instanceLabels,
      }),
    alerts:
      alertsOverview.grafana.panels.alertsOverview
      // With Job set to All, the library's label filter also lists other integrations' alerts.
      + g.panel.alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(
        alertsOverview.signals.alerts.getVariables().queriesSelectorAdvancedSyntax + ',alertname=~"SNMP.*"'
      ),
  },
}
