local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, this):: {
    temperature:
      signals.temperature.temperature.asTimeSeries()
      + commonlib.panels.hardware.timeSeries.temperature.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),
  },
}
