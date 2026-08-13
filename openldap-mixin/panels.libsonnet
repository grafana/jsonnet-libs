local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local signals = this.signals,
      local stat = g.panel.stat,
      local timeSeriesPanel = g.panel.timeSeries,
      local alertListPanel = g.panel.alertList,
      // The counter panels bucket by $__interval, so pin a floor matching the
      // OpenLDAP exporter's scrape interval.
      local withInterval = timeSeriesPanel.queryOptions.withInterval('1m'),

      // Uptime Panel
      uptime: signals.overview.uptime.asStat()
              + commonlib.panels.generic.stat.info.stylize()
              + stat.options.withTextMode('value')
              + stat.standardOptions.withMin(0),

      // Referrals Panel
      referrals: signals.overview.referrals.asStat()
                 + commonlib.panels.generic.stat.info.stylize()
                 + stat.options.withTextMode('value')
                 + stat.standardOptions.withMin(0),

      alerts:
        alertListPanel.new('OpenLDAP alerts')
        + alertListPanel.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesSelectorAdvancedSyntax),

      // Directory Entries Panel
      directoryEntries: signals.overview.directoryEntries.asTimeSeries()
                        + commonlib.panels.generic.timeSeries.base.stylize()
                        + withInterval
                        + timeSeriesPanel.standardOptions.withMin(0)
                        + timeSeriesPanel.standardOptions.withDecimals(0),

      // Connections Panel
      connections: signals.connections.connections.asTimeSeries()
                   + commonlib.panels.generic.timeSeries.base.stylize()
                   + withInterval
                   + timeSeriesPanel.standardOptions.withMin(0)
                   + timeSeriesPanel.standardOptions.withDecimals(0),

      // Waiters Panel
      waiters: commonlib.panels.generic.timeSeries.base.new(
                 'Waiters',
                 targets=[
                   signals.connections.readWaiters.asTarget(),
                   signals.connections.writeWaiters.asTarget(),
                 ],
                 description='The number of read and write waiters.'
               )
               + timeSeriesPanel.standardOptions.withUnit('none')
               + timeSeriesPanel.standardOptions.withMin(0)
               + timeSeriesPanel.standardOptions.withDecimals(0),

      // Network Connectivity Panel
      networkConnectivity: signals.connections.networkConnectivity.asTimeSeries()
                           + commonlib.panels.generic.timeSeries.base.stylize()
                           + withInterval
                           + timeSeriesPanel.standardOptions.withMin(0)
                           + timeSeriesPanel.standardOptions.withDecimals(0),

      // PDU Processed Panel
      pduProcessed: signals.operations.pduProcessed.asTimeSeries()
                    + commonlib.panels.generic.timeSeries.base.stylize()
                    + withInterval
                    + timeSeriesPanel.standardOptions.withMin(0)
                    + timeSeriesPanel.standardOptions.withDecimals(0),

      // Authentication Attempts Panel
      authenticationAttempts: signals.authentication.authAttempts.asTimeSeries()
                              + commonlib.panels.generic.timeSeries.base.stylize()
                              + withInterval
                              + timeSeriesPanel.standardOptions.withMin(0)
                              + timeSeriesPanel.standardOptions.withDecimals(0),

      // Core Operations Panel
      coreOperations: commonlib.panels.generic.timeSeries.base.new(
                        'Core operations / $__interval',
                        targets=[
                          signals.operations.addOperations.asTarget(),
                          signals.operations.bindOperations.asTarget(),
                          signals.operations.modifyOperations.asTarget(),
                          signals.operations.searchOperations.asTarget(),
                          signals.operations.deleteOperations.asTarget(),
                        ],
                        description='The key LDAP operations.'
                      )
                      + withInterval
                      + timeSeriesPanel.options.legend.withDisplayMode('table')
                      + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean'])
                      + timeSeriesPanel.options.legend.withPlacement('right')
                      + timeSeriesPanel.standardOptions.withUnit('none')
                      + timeSeriesPanel.standardOptions.withMin(0)
                      + timeSeriesPanel.standardOptions.withDecimals(0),

      // Auxiliary Operations Panel
      auxiliaryOperations: commonlib.panels.generic.timeSeries.base.new(
                             'Auxiliary operations / $__interval',
                             targets=[
                               signals.operations.abandonOperations.asTarget(),
                               signals.operations.compareOperations.asTarget(),
                               signals.operations.unbindOperations.asTarget(),
                               signals.operations.extendedOperations.asTarget(),
                               signals.operations.modrdnOperations.asTarget(),
                             ],
                             description='The less frequent but important LDAP operations.'
                           )
                           + withInterval
                           + timeSeriesPanel.options.legend.withDisplayMode('table')
                           + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean'])
                           + timeSeriesPanel.options.legend.withPlacement('right')
                           + timeSeriesPanel.standardOptions.withUnit('none')
                           + timeSeriesPanel.standardOptions.withMin(0)
                           + timeSeriesPanel.standardOptions.withDecimals(0),

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
                             + timeSeriesPanel.standardOptions.withUnit('none')
                             + timeSeriesPanel.standardOptions.withMin(0)
                             + timeSeriesPanel.standardOptions.withDecimals(0),

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
                             + timeSeriesPanel.standardOptions.withUnit('none')
                             + timeSeriesPanel.standardOptions.withMin(0)
                             + timeSeriesPanel.standardOptions.withDecimals(0),
    },
}
