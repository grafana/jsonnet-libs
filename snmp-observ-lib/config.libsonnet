{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="integrations/snmp"
  zookeeperfilteringSelector: this.filteringSelector,
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  uid: 'snmp',
  dashboardNamePrefix: '',
  dashboardTags: ['snmp'],
  metricsSource: ['generic', 'dlink_des', 'juniper', 'cisco'],
  signals+:
    {
      cpu: (import './signals/cpu.libsonnet')(this),
      fleetInterface: (import './signals/interface.libsonnet')(this, level='fleet'),
      memory: (import './signals/memory.libsonnet')(this),
      interface: (import './signals/interface.libsonnet')(this, level='interface'),
      system: (import './signals/system.libsonnet')(this),
    },
}
