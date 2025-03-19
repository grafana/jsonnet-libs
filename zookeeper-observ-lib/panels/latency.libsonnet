local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    minLatency:
      signals.latency.minLatency.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    maxLatency:
      signals.latency.maxLatency.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    avgLatency:
      signals.latency.avgLatency.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

  },
}
