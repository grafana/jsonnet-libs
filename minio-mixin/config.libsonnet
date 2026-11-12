{
  local this = self,

  // Static selector added to every dashboard and alert query, e.g. job="integrations/minio".
  filteringSelector: '',
  groupLabels: ['job'],
  instanceLabels: ['instance'],

  uid: 'minio',
  dashboardNamePrefix: 'MinIO ',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Sources defined in signals/*.libsonnet: 'prometheus'.
  metricsSource: ['prometheus'],

  // Alert thresholds.
  alertsWarningStorageUsed: 80,  // %, for 1m

  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    storage: (import './signals/storage.libsonnet')(this),
    buckets: (import './signals/buckets.libsonnet')(this),
    requests: (import './signals/requests.libsonnet')(this),
    network: (import './signals/network.libsonnet')(this),
    alerts: (import './signals/alerts.libsonnet')(this),
  },
}
