local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
// Uptime panel. expects duration in seconds as input
base {
  new(title='Uptime', targets, description=''):
    super.new(title, targets, description)
    + stat.standardOptions.withDecimals(1)
    + stat.standardOptions.withUnit('dtdurations')
    + stat.options.withColorMode('thresholds')
    + stat.options.withGraphMode('none')
    + stat.standardOptions.thresholds.withMode('absolute')
    + stat.standardOptions.thresholds.withSteps(
      [
        stat.thresholdStep.withColor('text')
        + stat.thresholdStep.withValue(null),
        // Warn with orange color when uptime resets (first 10 minutes)
        stat.thresholdStep.withColor('orange')
        + stat.thresholdStep.withValue(600),
      ]
    )
    + stat.options.withReduceOptions({})
    + stat.options.reduceOptions.withCalcsMixin([
        'lastNotNull',
      ]
    )
}
