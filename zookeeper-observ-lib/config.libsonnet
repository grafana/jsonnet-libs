{
  local this = self,
  filteringSelector: 'job!=""',
  groupLabels: ['cluster'],
  instanceLabels: ['instance'],
  uid: 'zookeeper',
  dashboardNamePrefix: '',
  dashboardTags: ['zookeeper'],
  metricsSource: 'prometheus',  //or grafanacloud
  signals+:
    {
      cluster: (import './signals/cluster.libsonnet')(this),
      zookeeper: (import './signals/zookeeper.libsonnet')(this),
      latency: (import './signals/latency.libsonnet')(this),
    },
}
