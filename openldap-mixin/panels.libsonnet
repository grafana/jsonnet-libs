local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local t = this.grafana.targets,
      local statPanel = g.panel.stat,
      local timeSeriesPanel = g.panel.timeSeries,
      local alertListPanel = g.panel.alertList,

      // Uptime Panel
      uptime: statPanel.new(
        'Uptime',
        targets=[t.uptime],
        description='The total time since the LDAP server was last started.'
      ),

      // Referrals Panel
      referrals: statPanel.new(
        'Referrals',
        targets=[t.referrals],
        description='The number of LDAP referrals.'
      ),

      // Alerts Panel
      alerts: alertListPanel.new(
        'Alerts',
        targets=[],
        description='Panel to report on the status of firing alerts.'
      ),

      // Directory Entries Panel
      directoryEntries: timeSeriesPanel.new(
        'Directory Entries / $__interval',
        targets=[t.directoryEntries('__interval')],
        description='The total increase of new directory entries added over time.'
      ),

      // Connections Panel
      connections: timeSeriesPanel.new(
        'Connections / $__interval',
        targets=[t.connections('__interval')],
        description='The increase of new LDAP connections over time.'
      ),

      // Waiters Panel
      waiters: timeSeriesPanel.new(
        'Waiters',
        targets=[t.waiters('Read'), t.waiters('Write')],
        description='The number of read and write waiters.'
      ),

      // Network Connectivity Panel
      networkConnectivity: timeSeriesPanel.new(
        'Network Connectivity / $__interval',
        targets=[t.networkConnectivity('__interval')],
        description='The LDAP network connection attempts over time.'
      ),

      // PDU Processed Panel
      pduProcessed: timeSeriesPanel.new(
        'PDU Processed / $__interval',
        targets=[t.pduProcessed('__interval')],
        description='The number of LDAP Protocol Data Units (PDUs) processed over time.'
      ),

      // Authentication Attempts Panel
      authenticationAttempts: timeSeriesPanel.new(
        'Authentication Attempts / $__interval',
        targets=[t.authenticationAttempts('__interval')],
        description='The total increase of authentication attempts over time.'
      ),

      // Core Operations Panel
      coreOperations: timeSeriesPanel.new(
        'Core Operations / $__interval',
        targets=[
          t.coreOperations('Add', '__interval'),
          t.coreOperations('Bind', '__interval'),
          t.coreOperations('Modify', '__interval'),
          t.coreOperations('Search', '__interval'),
          t.coreOperations('Delete', '__interval'),
        ],
        description='The key LDAP operations.'
      ),

      // Auxiliary Operations Panel
      auxiliaryOperations: timeSeriesPanel.new(
        'Auxiliary Operations / $__interval',
        targets=[
          t.auxiliaryOperations('Abandon', '__interval'),
          t.auxiliaryOperations('Compare', '__interval'),
          t.auxiliaryOperations('Unbind', '__interval'),
          t.auxiliaryOperations('Extended', '__interval'),
          t.auxiliaryOperations('Modrdn', '__interval'),
        ],
        description='The less frequent but important LDAP operations.'
      ),

      // Primary Thread Activity Panel
      primaryThreadActivity: timeSeriesPanel.new(
        'Primary Thread Activity',
        targets=[
          t.primaryThreadActivity,
        ],
        description='The active, open, and maximum threads in the LDAP server.'
      ),

      // Thread Queue Management Panel
      threadQueueManagement: timeSeriesPanel.new(
        'Thread Queue Management',
        targets=[
          t.threadQueueManagement('Starting'),
          t.threadQueueManagement('Pending'),
          t.threadQueueManagement('Max Pending'),
          t.threadQueueManagement('Backload'),
        ],
        description='The LDAP server\'s thread backlog and pending status.'
      ),
    },
}
