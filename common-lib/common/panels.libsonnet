local g = import 'g.libsonnet';

{
  stat: {
    local stat = g.panel.stat,
    base(title, targets):
      stat.new(title)
      + stat.queryOptions.withTargets(targets)
      + stat.queryOptions.withInterval('1m')
      + stat.options.text.withValueSize(20),
    
    // up (availability) panel
    up(title, targets):
      self.base(title, targets)
      + stat.options.withColorMode('none')
      + stat.options.withGraphMode('none')
      + stat.options.reduceOptions.withCalcs([
        'lastNotNull',
      ]),
    
    //uptime panel. expects duration in seconds as input
    uptime(title, targets):
      self.base(title, targets)
      + stat.standardOptions.withDecimals(1)
      + stat.standardOptions.withUnit('dtdurations')
      + stat.options.withColorMode('thresholds')
      + stat.options.withGraphMode('none')
      + stat.standardOptions.thresholds.withMode('absolute')
      + stat.standardOptions.thresholds.withSteps(
        [
          stat.options.thresholdStep.withColor('text')
          + stat.options.thresholdStep.withValue(null),
          // warn with orange color when uptime resets (5 minutes)
          stat.options.thresholdStep.withColor('orange')
          + stat.options.thresholdStep.withValue(300),
        ]
      )
      + stat.options.reduceOptions.withCalcs([
        'lastNotNull',
      ]),
  },
  timeSeries: {
    local timeSeries = g.panel.timeSeries,
    local fieldOverride = g.panel.timeSeries.fieldOverride,
    local custom = timeSeries.fieldConfig.defaults.custom,
    local defaults = timeSeries.fieldConfig.defaults,
    local options = timeSeries.options,


    base(title, targets):
      timeSeries.new(title)
      + timeSeries.queryOptions.withTargets(targets)
      + timeSeries.queryOptions.withInterval('1m')
      + custom.withLineWidth(2)
      + custom.withFillOpacity(0)
      + custom.withShowPoints('never'),

    rpcRate(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('ops'),
    activeStreams(title, targets):
      self.base(title, targets),
    dbSize(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('bytes'),
    diskSync(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('s'),
    memory(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('bytes'),
    traffic(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('Bps'),
    raftProposals(title, targets):
      self.base(title, targets),
    leaderElections(title, targets):
      self.base(title, targets),
    peerRtt(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('s'),
  },
}