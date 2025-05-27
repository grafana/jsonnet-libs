{
  enableMultiCluster: false,
  filteringSelector: 'job=~".*/clickhouse.*"',
  groupLabels: if self.enableMultiCluster then ["job", "cluster"] else ["job"],
  instanceLabels: ["instance"],
  dashboardTags: ["clickhouse-mixin"],
  uid: "clickhouse",
  dashboardNamePrefix: "ClickHouse",

  // additional params
  dashboardPeriod: "now-30m",
  dashboardTimezone: "default",
  dashboardRefresh: "1m",

  enableLokiLogs: true,
  logLabels: if self.enableMultiCluster then ["job", "instance", "cluster", "level"] else ["job", "instance", "level"],
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: "level",
  showLogsVolume: true,

  // alerts params
  alertsReplicasMaxQueueSize: "99",
}
