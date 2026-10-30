local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    local signals = this.signals,
    local tagKeys = std.join(',', this.config.groupLabels + this.config.instanceLabels),

    reboot:
      commonlib.annotations.reboot.new(
        title='Reboot',
        target=signals.host.bootTime.asTarget()
               + { expr: '(%s) * 1000 > $__from < $__to' % signals.host.bootTime.asPanelExpression() },
        instanceLabels=std.join(',', this.config.instanceLabels),
      )
      + commonlib.annotations.base.withTagKeys(tagKeys),

    osChange:
      commonlib.annotations.base.new(
        title='OS or kernel change',
        target=signals.host.osChanges.asTarget(),
      )
      + commonlib.annotations.base.withTagKeys(tagKeys)
      + commonlib.annotations.base.withTextFormat('')
      + {
        hide: true,
        iconColor: 'light-blue',
        step: '5m',
      },
  },
}
