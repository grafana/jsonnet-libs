local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    critical:
      commonlib.annotations.critical.new(
        title='Critical alert',
        target=this.signals.alerts.alertsCritical.asTarget(),
      )
      {
        textFormat: '{{alertname}}',
        hide: true,
      }
      + commonlib.annotations.base.withTagKeys(std.join(',', this.config.groupLabels + this.config.instanceLabels)),
    warning:
      commonlib.annotations.warning.new(
        title='Warning alert',
        target=this.signals.alerts.alertsWarning.asTarget(),
      )
      {
        textFormat: '{{alertname}}',
        hide: true,
      }
      + commonlib.annotations.base.withTagKeys(std.join(',', this.config.groupLabels + this.config.instanceLabels)),
    info:
      commonlib.annotations.info.new(
        title='Info message',
        target=this.signals.alerts.alertsInfo.asTarget(),
      )
      {
        textFormat: '{{alertname}}',
        hide: true,
      }
      + commonlib.annotations.base.withTagKeys(std.join(',', this.config.groupLabels + this.config.instanceLabels)),
  },
}
