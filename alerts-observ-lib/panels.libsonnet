local g = import './g.libsonnet';

{
  new(this): {
    local alertList = g.panel.alertList,
    alertsOverview:
      alertList.new('Alerts')
      + alertList.panelOptions.withDescription('Currently firing alerts.')
      + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.signals.alerts.getVariables().queriesSelectorAdvancedSyntax)
      + alertList.options.UnifiedAlertListOptions.withGroupMode(this.config.groupMode)
      + if this.config.groupMode == 'custom' then alertList.options.UnifiedAlertListOptions.withGroupBy(this.config.groupLabels) else {},
  },
}
