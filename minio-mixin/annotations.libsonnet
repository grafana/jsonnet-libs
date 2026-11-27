local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    local tagKeys = std.join(',', this.config.groupLabels + this.config.instanceLabels);
    {
      critical:
        commonlib.annotations.critical.new(
          title='Critical alert',
          target=this.signals.alerts.alertsCritical.asTarget(),
        )
        + commonlib.annotations.base.withTextFormat('{{alertname}}')
        + commonlib.annotations.base.withTagKeys(tagKeys),
      warning:
        commonlib.annotations.warning.new(
          title='Warning alert',
          target=this.signals.alerts.alertsWarning.asTarget(),
        )
        + commonlib.annotations.base.withTextFormat('{{alertname}}')
        + commonlib.annotations.base.withTagKeys(tagKeys)
        + { hide: true },
    },
}
