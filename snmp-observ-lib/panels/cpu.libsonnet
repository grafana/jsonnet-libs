local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, this):: {

    cpuUsage:
      signals.cpu.cpuUsage.asTimeSeries('CPU usage')
      + commonlib.panels.cpu.timeSeries.utilization.stylize(),

  },
}
