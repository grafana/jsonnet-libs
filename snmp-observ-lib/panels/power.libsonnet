local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(signals, this):: {
    dcVoltage:
      signals.power.dcVoltage.asTimeSeries()
      + commonlib.panels.hardware.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),

    rxtxPower:
      signals.power.rxtxPower.asTimeSeries()
      + commonlib.panels.hardware.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),
    power:
      signals.power.power.asTimeSeries()
      + commonlib.panels.hardware.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0),
  },
}
