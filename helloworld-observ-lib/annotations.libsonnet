local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    local grafana = this.grafana;
    local instanceLabels = this.config.instanceLabels;
    local groupLabels = this.config.groupLabels;
    {
      reboot:
        commonlib.annotations.reboot.new(
          title='Reboot',
          target=this.grafana.targets.uptime1,
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
            target=this.grafana.targets.lokiQuery1,
          )
          + commonlib.annotations.base.withTagKeys(std.join(',', groupLabels + instanceLabels + ['level']))
          + commonlib.annotations.base.withTextFormat('{{message}}'),
      }
    else
      {},

}
