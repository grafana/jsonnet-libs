local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals):: {
    producerConversion:
      signals.conversion.producerConversion.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    consumerConversion:
      signals.conversion.consumerConversion.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

  },
}
