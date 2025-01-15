local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, this):: {
    memoryUsage:
      signals.memory.memoryUsage.asTimeSeries()
      + commonlib.panels.memory.timeSeries.usagePercent.stylize(),
  },
}
