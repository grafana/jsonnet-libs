local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, this):: {
    fanSpeed:
      signals.fans.fanSpeed.asTimeSeries()
      + commonlib.panels.hardware.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),

  },
}
