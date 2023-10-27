{
  _config+:: {
    filterSelector: 'job=~"integrations/apache-hbase"',

    dashboardTags: ['apache-hbase-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsHighHeapMemUsage: 80,  // percentage
    alertsHighNonHeapMemUsage: 80,  // percentage
    alertsDeadRegionServer: 0,  // count
    alertsOldRegionsInTransition: 50,  // percentage
    alertsHighMasterAuthFailRate: 35,  // percentage
    alertsHighRSAuthFailRate: 35,  // percentage

    enableLokiLogs: true,
  },
}
