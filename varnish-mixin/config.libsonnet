{
  local this = self,
  filteringSelector: 'job="integrations/varnish-cache"',
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],
  dashboardTags: ['varnish-mixin'],
  uid: 'varnish',
  dashboardNamePrefix: 'Varnish',

  // additional params
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // logs lib related
  enableLokiLogs: true,
  logLabels: ['job', 'instance', 'cluster', 'level'],
  extraLogLabels: [],  // Required by logs-lib
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,

  // alert thresholds
  alertsWarningCacheHitRate: 80,  //%
  alertsWarningHighMemoryUsage: 90,  //%
  alertsCriticalCacheEviction: 0,
  alertsWarningHighSaturation: 0,
  alertsCriticalSessionsDropped: 0,
  alertsCriticalBackendUnhealthy: 0,

  // metrics source for signals library
  metricsSource: 'prometheus',

  legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
  signals+: {
    cache: (import './signals/cache.libsonnet')(this),
    requests: (import './signals/requests.libsonnet')(this),
    sessions: (import './signals/sessions.libsonnet')(this),
    memory: (import './signals/memory.libsonnet')(this),
    network: (import './signals/network.libsonnet')(this),
    threads: (import './signals/threads.libsonnet')(this),
    backend: (import './signals/backend.libsonnet')(this),
  },
}
