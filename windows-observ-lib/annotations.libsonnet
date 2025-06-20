local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local config = this.config,
    local signals = this.signals,

    reboot: commonlib.annotations.reboot.new(
      title='Reboot',
      target=signals.system.bootTime.asTarget() +
        {
          expr: signals.system.bootTime.asPanelExpression() + '*1000 > $__from < $__to',
        },
      instanceLabels=std.join(',', config.instanceLabels),
    )
    + commonlib.annotations.base.withTagKeys(std.join(',', config.groupLabels + config.instanceLabels)),

    serviceFailed: if config.enableLokiLogs then
      commonlib.annotations.serviceFailed.new(
        title='Service failed',
        target=signals.logs.serviceFailedLogs.asTarget(),
      )
      + commonlib.annotations.base.withTagKeys(std.join(',', config.groupLabels + config.instanceLabels + ['level']))
      + commonlib.annotations.base.withTextFormat('{{message}}')
    else {},

    criticalEvents: if config.enableLokiLogs then
      commonlib.annotations.fatal.new(
        title='Critical system event',
        target=signals.logs.criticalEventsLogs.asTarget(),
      )
      + commonlib.annotations.base.withTagKeys(std.join(',', config.groupLabels + config.instanceLabels + ['level']))
      + commonlib.annotations.base.withTextFormat('{{message}}')
    else {},
  },
} 