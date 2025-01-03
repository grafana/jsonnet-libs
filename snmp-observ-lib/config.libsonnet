{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="integrations/snmp"
  zookeeperfilteringSelector: this.filteringSelector,
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  uid: 'snmp',
  dashboardNamePrefix: '',
  dashboardTags: ['snmp'],
  metricsSource: ['prometheus'],
  signals+:
    {
      cpu: (import './signals/cpu.libsonnet')(this),
      memory: (import './signals/memorynetwork.libsonnet')(this),
      interface: (import './signals/interface.libsonnet')(this),
      system: (import './signals/system.libsonnet')(this),
    },
}
