local g = import '../../g.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
//uptime panel. expects duration in seconds as input
{
  new(title='Uptime', targets, description=''):
    base.new(title, targets, description)
    + stat.standardOptions.withDecimals(1)
    + stat.standardOptions.withUnit('dtdurations')
    + stat.options.withColorMode('thresholds')
    + stat.options.withGraphMode('none')
    + stat.standardOptions.thresholds.withMode('absolute')
    + stat.standardOptions.thresholds.withSteps(
      [
        stat.thresholdStep.withColor('text')
        + stat.thresholdStep.withValue(null),
        // warn with orange color when uptime resets (5minutes)
        stat.thresholdStep.withColor('orange')
        + stat.thresholdStep.withValue(300),
      ]
    )
    + stat.options.reduceOptions.withCalcs([
      'lastNotNull',
    ])
}