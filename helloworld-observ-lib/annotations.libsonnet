local commonlib = import 'common-lib/common/main.libsonnet';
local g = import 'g.libsonnet';
{
  new(this):
    local grafana = this.grafana;
    local instanceLabels = this.config.instanceLabels;
    local groupLabels = this.config.groupLabels;
    {
      reboot:
        commonlib.annotations.reboot.new(
          title='Reboot',
          target=
          g.query.prometheus.new(
            '${' + this.grafana.variables.datasources.prometheus.name + '}',
            this.signals.uptime1.asPanelExpression(),
          )
          ,
          instanceLabels=std.join(',', instanceLabels),
        )
        + commonlib.annotations.base.withTagKeys(std.join(',', groupLabels + instanceLabels)),
    }
    +
    if
      this.config.enableLokiLogs
    // add logs-based annotations only if loki enabled
    then
      {
        criticalEvents:
          commonlib.annotations.base.new(
            title='Interesting system event from logs',
            target=
            g.query.loki.new(
              '${' + this.grafana.variables.datasources.loki.name + '}',
              this.signals.logsErrors.asPanelExpression(),
            )
          )
          + commonlib.annotations.base.withTagKeys(std.join(',', groupLabels + instanceLabels + ['level']))
          + commonlib.annotations.base.withTextFormat('{{message}}'),
      }
    else
      {},

}
