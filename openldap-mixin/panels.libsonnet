local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local signals = this.signals,
      // The counter panels bucket by $__interval, so pin a floor matching the
      // OpenLDAP exporter's scrape interval.
      local withInterval = g.panel.timeSeries.queryOptions.withInterval('1m'),

      uptime:
        signals.overview.uptime.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + g.panel.stat.options.withTextMode('value')
        + g.panel.stat.standardOptions.withMin(0),

      referrals:
        signals.overview.referrals.asStat()
        + commonlib.panels.generic.stat.info.stylize()
        + g.panel.stat.options.withTextMode('value')
        + g.panel.stat.standardOptions.withMin(0),

      // common-lib has no alertList prototype (generic covers stat, timeSeries,
      // table and statusHistory only), so this one stays on grafonnet.
      alerts:
        g.panel.alertList.new('OpenLDAP alerts')
        + g.panel.alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesSelectorAdvancedSyntax),

      directoryEntries:
        signals.overview.directoryEntries.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + withInterval
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),

      connections:
        signals.connections.connections.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + withInterval
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),

      waiters:
        commonlib.panels.generic.timeSeries.base.new(
          'Waiters',
          targets=[
            signals.connections.readWaiters.asTarget(),
            signals.connections.writeWaiters.asTarget(),
          ],
          description='The number of read and write waiters.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),

      networkConnectivity:
        signals.connections.networkConnectivity.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + withInterval
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),

      pduProcessed:
        signals.operations.pduProcessed.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + withInterval
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),

      authenticationAttempts:
        signals.authentication.authAttempts.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + withInterval
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),

      coreOperations:
        commonlib.panels.generic.timeSeries.base.new(
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
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),

      auxiliaryOperations:
        commonlib.panels.generic.timeSeries.base.new(
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
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),

      primaryThreadActivity:
        commonlib.panels.generic.timeSeries.base.new(
          'Primary thread activity',
          targets=[
            signals.threads.openThreads.asTarget(),
            signals.threads.activeThreads.asTarget(),
            signals.threads.maxThreads.asTarget(),
          ],
          description='The active, open, and maximum threads in the LDAP server.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),

      threadQueueManagement:
        commonlib.panels.generic.timeSeries.base.new(
          'Thread queue management',
          targets=[
            signals.threads.startingThreads.asTarget(),
            signals.threads.pendingThreads.asTarget(),
            signals.threads.maxPendingThreads.asTarget(),
            signals.threads.backloadThreads.asTarget(),
          ],
          description="The LDAP server's thread backlog and pending status."
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0),
    },
}
