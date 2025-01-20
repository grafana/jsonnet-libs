{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="integrations/snmp"
  zookeeperfilteringSelector: this.filteringSelector,
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  uid: 'snmp',
  dashboardNamePrefix: '',
  dashboardTags: ['snmp'],
  dashboardPeriod: 'now-6h',
  dashboardRefresh: '5m',
  dashboardTimezone: '',

  //increase min interval to match max SNMP polling interval used:
  minInterval: '30s',

  //only fire alerts 'interface is down' for the following selector:
  alertInterfaceDownSelector: 'ifAlias=~".*(?i:(uplink|internet|WAN).*"',
  alertMemoryUsageThresholdCritical: 90,
  alertsCPUThresholdWarning: 90,
  signals+:
    {
      cpu: (import './signals/cpu.libsonnet')(this),
      fleetInterface: (import './signals/interface.libsonnet')(this, level='fleet'),
      memory: (import './signals/memory.libsonnet')(this),
      interface: (import './signals/interface.libsonnet')(this, level='interface'),
      system: (import './signals/system.libsonnet')(this),
    },
}
