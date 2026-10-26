{
  _config+:: {
    dashboardTags: ['grafana-agent'],
    dashboardPeriod: 'now-1h',
    dashboardRefresh: '1m',
    dashboardTimezone: 'default',

    //alert thresholds
    alertsCriticalCpuUsage5m: 80,  //percent
    alertsCriticalMemUsage5m: 100,  //kilo bytes per active series
    enableLokiLogs: true,
  },
}
