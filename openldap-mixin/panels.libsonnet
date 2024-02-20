local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local t = this.grafana.targets,
      local stat = g.panel.stat,
      local timeSeriesPanel = g.panel.timeSeries,
      local alertListPanel = g.panel.alertList,

      // Uptime Panel
      uptime: commonlib.panels.generic.stat.base.new(
                'Uptime',
                targets=[t.uptime],
                description='The total time since the LDAP server was last started.'
              )
              + stat.options.withGraphMode('none')
              + stat.options.withColorMode("value")
              + stat.options.withJustifyMode("auto")
              + stat.options.withOrientation("auto")
              + stat.options.reduceOptions.withCalcs(['lastNotNull'])
              + stat.options.reduceOptions.withFields("")
              + stat.options.reduceOptions.withValues(false)
              + stat.options.withTextMode("value")

              + stat.standardOptions.withUnit("s")
              + stat.standardOptions.withMin(0)
              + stat.standardOptions.color.withMode('thresholds')
              + stat.standardOptions.thresholds.withMode("absolute")
              + stat.standardOptions.thresholds.withSteps([
                stat.thresholdStep.withColor('green')
              ]),


      // Referrals Panel
      referrals: commonlib.panels.generic.stat.base.new(
        'Referrals',
        targets=[t.referrals],
        description='The number of LDAP referrals.'
      ),

      alerts: 
        alertListPanel.new('OpenLDAP alerts')
        + alertListPanel.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      // Directory Entries Panel
      directoryEntries: commonlib.panels.generic.timeSeries.base.new(
                          'Directory entries / $__interval',
                          targets=[t.directoryEntries('__interval')],
                          description='The total increase of new directory entries added over time.'
                        )
                        + timeSeriesPanel.options.legend.withDisplayMode('list'),

      // Connections Panel
      connections: commonlib.panels.generic.timeSeries.base.new(
                     'Connections / $__interval',
                     targets=[t.connections('__interval')],
                     description='The increase of new LDAP connections over time.'
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

      // Waiters Panel
      waiters: commonlib.panels.generic.timeSeries.base.new(
                 'Waiters',
                 targets=[t.waiters('Read'), t.waiters('Write')],
                 description='The number of read and write waiters.'
               )
               + timeSeriesPanel.options.legend.withDisplayMode('list'),

      // Network Connectivity Panel
      networkConnectivity: commonlib.panels.generic.timeSeries.base.new(
                             'Network connectivity / $__interval',
                             targets=[t.networkConnectivity('__interval')],
                             description='The LDAP network connection attempts over time.'
                           )
                           + timeSeriesPanel.options.legend.withDisplayMode('list'),

      // PDU Processed Panel
      pduProcessed: commonlib.panels.generic.timeSeries.base.new(
                      'PDU processed / $__interval',
                      targets=[t.pduProcessed('__interval')],
                      description='The number of LDAP Protocol Data Units (PDUs) processed over time.'
                    )
                    + timeSeriesPanel.options.legend.withDisplayMode('list'),

      // Authentication Attempts Panel
      authenticationAttempts: commonlib.panels.generic.timeSeries.base.new(
                                'Authentication attempts / $__interval',
                                targets=[t.authenticationAttempts('__interval')],
                                description='The total increase of authentication attempts over time.'
                              )
                              + timeSeriesPanel.options.legend.withDisplayMode('list'),

      // Core Operations Panel
      coreOperations: commonlib.panels.generic.timeSeries.base.new(
                        'Core operations / $__interval',
                        targets=[
                          t.coreOperations('Add', '__interval'),
                          t.coreOperations('Bind', '__interval'),
                          t.coreOperations('Modify', '__interval'),
                          t.coreOperations('Search', '__interval'),
                          t.coreOperations('Delete', '__interval'),
                        ],
                        description='The key LDAP operations.'
                      )
                      + timeSeriesPanel.options.legend.withDisplayMode('table')
                      + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean']),

      // Auxiliary Operations Panel
      auxiliaryOperations: commonlib.panels.generic.timeSeries.base.new(
                             'Auxiliary operations / $__interval',
                             targets=[
                               t.auxiliaryOperations('Abandon', '__interval'),
                               t.auxiliaryOperations('Compare', '__interval'),
                               t.auxiliaryOperations('Unbind', '__interval'),
                               t.auxiliaryOperations('Extended', '__interval'),
                               t.auxiliaryOperations('Modrdn', '__interval'),
                             ],
                             description='The less frequent but important LDAP operations.'
                           )
                           + timeSeriesPanel.options.legend.withDisplayMode('table')
                           + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean']),

      // Primary Thread Activity Panel
      primaryThreadActivity: commonlib.panels.generic.timeSeries.base.new(
                               'Primary thread activity',
                               targets=[
                                 t.threadQueueManagement('Open'),
                                 t.threadQueueManagement('Active'),
                                 t.threadQueueManagement('Max'),
                               ],
                               description='The active, open, and maximum threads in the LDAP server.'
                             )
                             + timeSeriesPanel.options.legend.withDisplayMode('list')
                             + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean']),

      // Thread Queue Management Panel
      threadQueueManagement: commonlib.panels.generic.timeSeries.base.new(
                               'Thread queue management',
                               targets=[
                                 t.threadQueueManagement('Starting'),
                                 t.threadQueueManagement('Pending'),
                                 t.threadQueueManagement('Max Pending'),
                                 t.threadQueueManagement('Backload'),
                               ],
                               description="The LDAP server's thread backlog and pending status."
                             )
                             + timeSeriesPanel.options.legend.withDisplayMode('list')
                             + timeSeriesPanel.options.legend.withCalcsMixin(['min', 'max', 'mean']),
    },
}
