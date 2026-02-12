local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {

    //
    // Elections panels
    //

    stepUpElectionsCalled:
      commonlib.panels.generic.timeSeries.base.new('Step-up elections / $__interval', targets=[
        signals.elections.stepUpCmdCalled.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.elections.stepUpCmdSuccessful.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when the primary stepped down.')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    priorityElections:
      commonlib.panels.generic.timeSeries.base.new('Priority elections / $__interval', targets=[
        signals.elections.priorityTakeoverCalled.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.elections.priorityTakeoverSuccessful.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when it had a higher priority than the primary node.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    takeoverElections:
      commonlib.panels.generic.timeSeries.base.new('Takeover elections / $__interval', targets=[
        signals.elections.catchUpTakeoverCalled.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.elections.catchUpTakeoverSuccessful.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when it was more current than the primary node.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    timeoutElections:
      commonlib.panels.generic.timeSeries.base.new('Timeout elections / $__interval', targets=[
        signals.elections.electionTimeoutCalled.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.elections.electionTimeoutSuccessful.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true)
      + g.panel.timeSeries.panelOptions.withDescription('The number of elections called and elections won by the node when the time it took to reach the primary node exceeded the election timeout limit.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsTotal:
      commonlib.panels.generic.timeSeries.base.new('Catch-ups / $__interval', targets=[
        signals.elections.numCatchUps.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node had to catch up to the highest known oplog entry.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsSkipped:
      commonlib.panels.generic.timeSeries.base.new('Catch-ups skipped / $__interval', targets=[
        signals.elections.numCatchUpsSkipped.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node skipped the catch up process when it was the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsSucceeded:
      commonlib.panels.generic.timeSeries.base.new('Catch-ups succeeded / $__interval', targets=[
        signals.elections.numCatchUpsSucceeded.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node succeeded in catching up when it was the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsFailed:
      commonlib.panels.generic.timeSeries.base.new('Catch-ups failed / $__interval', targets=[
        signals.elections.numCatchUpsFailedWithError.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node failed in catching up when it was the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catchUpsTimedOut:
      commonlib.panels.generic.timeSeries.base.new('Catch-up timeouts / $__interval', targets=[
        signals.elections.numCatchUpsTimedOut.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times the node timed out during the catch-up process when it was the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none'),

    averageCatchUpOps:
      commonlib.panels.generic.timeSeries.base.new('Average catch-up operations', targets=[
        signals.elections.averageCatchUpOps.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The average number of operations done during the catch-up process when this node is the newly elected primary.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),
  },
}
