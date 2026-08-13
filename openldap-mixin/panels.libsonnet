local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local signals = this.signals,
      local stat = g.panel.stat,
      local timeSeriesPanel = g.panel.timeSeries,
      local alertListPanel = g.panel.alertList,
      local withInterval = timeSeriesPanel.queryOptions.withInterval('1m'),

      // Uptime Panel
      uptime: signals.overview.uptime.asStat()
              + commonlib.panels.generic.stat.info.stylize()
              + stat.options.withTextMode('value')
              + stat.standardOptions.withMin(0)
              + stat.standardOptions.color.withMode('thresholds')
              + stat.standardOptions.thresholds.withMode('absolute')
              + stat.standardOptions.thresholds.withSteps([
                stat.thresholdStep.withColor('green'),
              ]),

      // Referrals Panel
      referrals: signals.overview.referrals.asStat()
                 + commonlib.panels.generic.stat.info.stylize()
                 + stat.options.withTextMode('value')
                 + stat.standardOptions.withMin(0)
                 + stat.standardOptions.color.withMode('thresholds')
                 + stat.standardOptions.thresholds.withMode('absolute')
                 + stat.standardOptions.thresholds.withSteps([
                   stat.thresholdStep.withColor('green'),
                 ]),

      alerts:
        alertListPanel.new('OpenLDAP alerts')
        + alertListPanel.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesSelectorAdvancedSyntax),

      // Directory Entries Panel
      directoryEntries: signals.overview.directoryEntries.asTimeSeries()
                        + commonlib.panels.generic.timeSeries.base.stylize()
                        + withInterval
                        + timeSeriesPanel.options.legend.withDisplayMode('list')
                        + timeSeriesPanel.standardOptions.withMin(0)
                        + timeSeriesPanel.standardOptions.withDecimals(0)
                        + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
                        + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
                        + timeSeriesPanel.standardOptions.thresholds.withSteps([
                          timeSeriesPanel.thresholdStep.withColor('green'),
                        ]),

      // Connections Panel
      connections: signals.connections.connections.asTimeSeries()
                   + commonlib.panels.generic.timeSeries.base.stylize()
                   + withInterval
                   + timeSeriesPanel.options.legend.withDisplayMode('list')
                   + timeSeriesPanel.standardOptions.withMin(0)
                   + timeSeriesPanel.standardOptions.withDecimals(0)
                   + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
                   + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
                   + timeSeriesPanel.standardOptions.thresholds.withSteps([
                     timeSeriesPanel.thresholdStep.withColor('green'),
                   ]),

      // Waiters Panel
      waiters: commonlib.panels.generic.timeSeries.base.new(
                 'Waiters',
                 targets=[
                   signals.connections.readWaiters.asTarget(),
                   signals.connections.writeWaiters.asTarget(),
                 ],
                 description='The number of read and write waiters.'
               )
               + timeSeriesPanel.options.legend.withDisplayMode('list')
               + timeSeriesPanel.standardOptions.withUnit('none')
               + timeSeriesPanel.standardOptions.withMin(0)
               + timeSeriesPanel.standardOptions.withDecimals(0)
               + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
               + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
               + timeSeriesPanel.standardOptions.thresholds.withSteps([
                 timeSeriesPanel.thresholdStep.withColor('green'),
               ]),

      // Network Connectivity Panel
      networkConnectivity: signals.connections.networkConnectivity.asTimeSeries()
                           + commonlib.panels.generic.timeSeries.base.stylize()
                           + withInterval
                           + timeSeriesPanel.options.legend.withDisplayMode('list')
                           + timeSeriesPanel.standardOptions.withMin(0)
                           + timeSeriesPanel.standardOptions.withDecimals(0)
                           + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
                           + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
                           + timeSeriesPanel.standardOptions.thresholds.withSteps([
                             timeSeriesPanel.thresholdStep.withColor('green'),
                           ]),

      // PDU Processed Panel
      pduProcessed: signals.operations.pduProcessed.asTimeSeries()
                    + commonlib.panels.generic.timeSeries.base.stylize()
                    + withInterval
                    + timeSeriesPanel.options.legend.withDisplayMode('list')
                    + timeSeriesPanel.standardOptions.withMin(0)
                    + timeSeriesPanel.standardOptions.withDecimals(0)
                    + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
                    + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
                    + timeSeriesPanel.standardOptions.thresholds.withSteps([
                      timeSeriesPanel.thresholdStep.withColor('green'),
                    ]),

      // Authentication Attempts Panel
      authenticationAttempts: signals.authentication.authAttempts.asTimeSeries()
                              + commonlib.panels.generic.timeSeries.base.stylize()
                              + withInterval
                              + timeSeriesPanel.options.legend.withDisplayMode('list')
                              + timeSeriesPanel.standardOptions.withMin(0)
                              + timeSeriesPanel.standardOptions.withDecimals(0)
                              + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
                              + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
                              + timeSeriesPanel.standardOptions.thresholds.withSteps([
                                timeSeriesPanel.thresholdStep.withColor('green'),
                              ]),

      // Core Operations Panel
      coreOperations: commonlib.panels.generic.timeSeries.base.new(
                        'Core operations / $__interval',
                        targets=[
                          signals.operations.addOperations.asTarget() + withInterval,
                          signals.operations.bindOperations.asTarget() + withInterval,
                          signals.operations.modifyOperations.asTarget() + withInterval,
                          signals.operations.searchOperations.asTarget() + withInterval,
                          signals.operations.deleteOperations.asTarget() + withInterval,
                        ],
                        description='The key LDAP operations.'
                      )
                      + timeSeriesPanel.options.legend.withDisplayMode('table')
                      + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean'])
                      + timeSeriesPanel.options.legend.withPlacement('right')
                      + timeSeriesPanel.options.legend.withShowLegend(true)
                      + timeSeriesPanel.standardOptions.withUnit('none')
                      + timeSeriesPanel.standardOptions.withMin(0)
                      + timeSeriesPanel.standardOptions.withDecimals(0)
                      + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
                      + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
                      + timeSeriesPanel.standardOptions.thresholds.withSteps([
                        timeSeriesPanel.thresholdStep.withColor('green'),
                      ]),

      // Auxiliary Operations Panel
      auxiliaryOperations: commonlib.panels.generic.timeSeries.base.new(
                             'Auxiliary operations / $__interval',
                             targets=[
                               signals.operations.abandonOperations.asTarget() + withInterval,
                               signals.operations.compareOperations.asTarget() + withInterval,
                               signals.operations.unbindOperations.asTarget() + withInterval,
                               signals.operations.extendedOperations.asTarget() + withInterval,
                               signals.operations.modrdnOperations.asTarget() + withInterval,
                             ],
                             description='The less frequent but important LDAP operations.'
                           )
                           + timeSeriesPanel.options.legend.withDisplayMode('table')
                           + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean'])
                           + timeSeriesPanel.options.legend.withPlacement('right')
                           + timeSeriesPanel.options.legend.withShowLegend(true)
                           + timeSeriesPanel.standardOptions.withUnit('none')
                           + timeSeriesPanel.standardOptions.withMin(0)
                           + timeSeriesPanel.standardOptions.withDecimals(0)
                           + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
                           + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
                           + timeSeriesPanel.standardOptions.thresholds.withSteps([
                             timeSeriesPanel.thresholdStep.withColor('green'),
                           ]),

      // Primary Thread Activity Panel
      primaryThreadActivity: commonlib.panels.generic.timeSeries.base.new(
                               'Primary thread activity',
                               targets=[
                                 signals.threads.openThreads.asTarget(),
                                 signals.threads.activeThreads.asTarget(),
                                 signals.threads.maxThreads.asTarget(),
                               ],
                               description='The active, open, and maximum threads in the LDAP server.'
                             )
                             + timeSeriesPanel.options.legend.withDisplayMode('table')
                             + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean'])
                             + timeSeriesPanel.options.legend.withPlacement('right')
                             + timeSeriesPanel.options.legend.withShowLegend(true)
                             + timeSeriesPanel.standardOptions.withUnit('none')
                             + timeSeriesPanel.standardOptions.withMin(0)
                             + timeSeriesPanel.standardOptions.withDecimals(0)
                             + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
                             + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
                             + timeSeriesPanel.standardOptions.thresholds.withSteps([
                               timeSeriesPanel.thresholdStep.withColor('green'),
                               timeSeriesPanel.thresholdStep.withValue(null),
                             ]),

      // Thread Queue Management Panel
      threadQueueManagement: commonlib.panels.generic.timeSeries.base.new(
                               'Thread queue management',
                               targets=[
                                 signals.threads.startingThreads.asTarget(),
                                 signals.threads.pendingThreads.asTarget(),
                                 signals.threads.maxPendingThreads.asTarget(),
                                 signals.threads.backloadThreads.asTarget(),
                               ],
                               description="The LDAP server's thread backlog and pending status."
                             )
                             + timeSeriesPanel.options.legend.withDisplayMode('table')
                             + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean'])
                             + timeSeriesPanel.options.legend.withPlacement('right')
                             + timeSeriesPanel.options.legend.withShowLegend(true)
                             + timeSeriesPanel.standardOptions.withUnit('none')
                             + timeSeriesPanel.standardOptions.withMin(0)
                             + timeSeriesPanel.standardOptions.withDecimals(0)
                             + timeSeriesPanel.standardOptions.color.withMode('palette-classic')
                             + timeSeriesPanel.standardOptions.thresholds.withMode('absolute')
                             + timeSeriesPanel.standardOptions.thresholds.withSteps([
                               timeSeriesPanel.thresholdStep.withColor('green'),
                               timeSeriesPanel.thresholdStep.withValue(null),
                             ]),
    },
}
