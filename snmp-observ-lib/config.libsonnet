{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="integrations/snmp"
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  uid: 'snmp',
  dashboardNamePrefix: '',
  dashboardTags: ['snmp'],
  dashboardPeriod: 'now-6h',
  dashboardRefresh: '5m',
  dashboardTimezone: '',

  //increase min interval to match max SNMP polling interval used:
  minInterval: '2m',
  metricsSource: ['generic', 'cisco', 'eltex_mes', 'mikrotik', 'juniper', 'dell_network'],

  //only fire alerts 'interface is down' for the following selector:
  alertInterfaceDownSelector: 'ifAlias=~".*(?i:(uplink|internet|WAN)).*"',
  // cpuSelector for metricsSources with HOST-RESOURCE-MIB:
  cpuSelector: 'hrDeviceType="1.3.6.1.2.1.25.3.1.3"',
  // memorySelector for metricsSources with HOST-RESOURCE-MIB:
  // ignore buffers for now:
  memorySelector: 'hrStorageDescr!~".*(?i:(cache|buffer)).*", hrStorageType="1.3.6.1.2.1.25.2.1.2"',
  mikrotikMemorySelector: 'hrStorageDescr="main memory",hrStorageIndex="65536"',
  // ignore interface sensors
  ciscoTemperatureSelector: 'entSensorType="8", entPhysicalName!~".+(\\\\d+/\\\\d+(/\\\\d+)?).*"',
  alertMemoryUsageThresholdCritical: 90,
  alertsCPUThresholdWarning: 90,
  signals+:
    {
      cpu: (import './signals/cpu.libsonnet')(this),
      fleetInterface: (import './signals/interface.libsonnet')(this, level='fleet'),
      memory: (import './signals/memory.libsonnet')(this),
      interface: (import './signals/interface.libsonnet')(this, level='interface'),
      system: (import './signals/system.libsonnet')(this),
      temperature: (import './signals/temperature.libsonnet')(this),
      power: (import './signals/power.libsonnet')(this),
      fans: (import './signals/fans.libsonnet')(this),
      fiber: (import './signals/fiber.libsonnet')(this),

    },
}
