{
  local this = self,

  // Basic filtering
  filteringSelector: 'job=~"$job", instance=~"$instance"',
  queriesSelector: 'job=~"$job", instance=~"$instance"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],

  // Dashboard settings
  dashboardTags: ['microsoft-iis-mixin'],
  uid: 'microsoft-iis',
  dashboardNamePrefix: 'Microsoft IIS',
  dashboardRefresh: '1m',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',

  // Logs configuration
  enableLokiLogs: true,
  logLabels: ['job', 'instance', 'level'],
  extraLogLabels: [],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // Alert thresholds
  alertsWarningHighRejectedAsyncIORequests: 20,  // count
  alertsCriticalHigh5xxRequests: 5,  // %
  alertsCriticalLowWebsocketConnectionSuccessRate: 80,  // %
  alertsCriticalHighThreadPoolUtilization: 90,  // %
  alertsWarningHighWorkerProcessFailures: 10,  // count

  // Metrics source
  metricsSource: 'prometheus',

  // Signal definitions
  signals+: {
    requests: (import './signals/requests.libsonnet')(this),
    connections: (import './signals/connections.libsonnet')(this),
    data_transfer: (import './signals/data_transfer.libsonnet')(this),
    async_io: (import './signals/async_io.libsonnet')(this),
    server_cache: (import './signals/server_cache.libsonnet')(this),
    app_pools: (import './signals/app_pools.libsonnet')(this),
    worker_processes: (import './signals/worker_processes.libsonnet')(this),
    worker_requests: (import './signals/worker_requests.libsonnet')(this),
    worker_cache: (import './signals/worker_cache.libsonnet')(this),
    worker_threads: (import './signals/worker_threads.libsonnet')(this),
    worker_websocket: (import './signals/worker_websocket.libsonnet')(this),
  },
}
