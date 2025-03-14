{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="bar"
  groupLabels: ['job'],
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
