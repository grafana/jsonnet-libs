{
  local this = self,

  filteringSelector: 'job=~"integrations/istio"',
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],

  uid: 'istio',
  metricsSource: 'prometheus',

  dashboardTags: [self.uid],
  dashboardNamePrefix: 'Istio',
  dashboardPeriod: 'now-30m',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  signals+: {
    overview: (import './signals/overview.libsonnet')(this),
    requests: (import './signals/requests.libsonnet')(this),
    tcp: (import './signals/tcp.libsonnet')(this),
    pilot: (import './signals/pilot.libsonnet')(this),
    sidecar: (import './signals/sidecar.libsonnet')(this),
    citadel: (import './signals/citadel.libsonnet')(this),
  },
}
