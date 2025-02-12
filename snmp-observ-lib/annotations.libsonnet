local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this):
    {

      critical: commonlib.annotations.fatal.new(
                  title='Critical alert',
                  target=this.signals.alerts.alertsCritical.asTarget(),
                )
                { textFormat: '{{alertname}}' }
                + commonlib.annotations.base.withTagKeys(std.join(',', this.config.groupLabels + this.config.instanceLabels)),
      warning: commonlib.annotations.base.new(
                 title='Warning alert',
                 target=this.signals.alerts.alertsWarning.asTarget(),
               )
               {
                 textFormat: '{{alertname}}',
                 hide: true,
               }
               + commonlib.annotations.base.withTagKeys(std.join(',', this.config.groupLabels + this.config.instanceLabels)),
    }
    +
    if
      this.config.enableLokiLogs
    then
      {
        criticalEvents: commonlib.annotations.fatal.new(
                          title='Critical event logged',
                          target=this.signals.logs.criticalLogs.asTarget()
                        )
                        + commonlib.annotations.base.withTagKeys(std.join(',', this.config.groupLabels + this.config.instanceLabels + this.config.extraLogLabels)),
      }
    else
      {},

}
