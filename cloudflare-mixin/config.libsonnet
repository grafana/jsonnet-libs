{
  local this = self,
  enableMultiCluster: false,
  filteringSelector: 'job="integrations/cloudflare"',
  groupLabels: ['job', 'cluster', 'zone', 'script_name'],
  instanceLabels: ['instance'],

  dashboardTags: [self.uid + '-mixin'],
  legendLabels: ['instance'],
  uid: 'cloudflare',
  dashboardNamePrefix: 'Cloudflare',

  // additional params
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',
  metricsSource: 'prometheus',

  // alerts thresholds
  alertsHighThreatCount: 3,  // count
  alertsHighRequestRate: 150,  // percentage
  alertsHighHTTPErrorCodeCount: 100,  // count

  signals+: {
    geomap: (import './signals/geomap.libsonnet')(this),
    zone: (import './signals/zone.libsonnet')(this),
    worker: (import './signals/worker.libsonnet')(this),
    pool: (import './signals/pool.libsonnet')(this),
  },
}
