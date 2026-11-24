local commonlib = import 'common-lib/common/main.libsonnet';

{
  local this = self,
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="integrations/snmp"
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  uid: 'snmp',
  dashboardNamePrefix: 'SNMP',
  dashboardTags: ['snmp'],
  dashboardPeriod: 'now-1h',
  dashboardRefresh: '1m',
  dashboardTimezone: commonlib.dashboards.defaultTimezone,

  //increase min interval to match max SNMP polling interval used:
  minInterval: '2m',
  // pick vendors you have. See README for full list.
  metricsSource: ['generic', 'cisco', 'mikrotik', 'juniper'],

  // only fire alerts 'interface is down' for the following selector:
  alertInterfaceDownSelectorWarning: 'ifAlias=~".*(?i:(uplink|internet|WAN|ISP)).*"',
  // change according to your org naming conventions
  alertInterfaceDownSelectorCritical: 'ifAlias=~".*(?i:(critical)).*"',

  // Enable to workaround issue with counters on Cisco NX-OS overloading issue.
  // This will clamp max interface traffic possible to 100Gbps.
  clampQueryEnabled: true,
  clampSpeed: '100*10^9',  // 100 Gbps

  // cpuSelector for metricsSources with HOST-RESOURCES-MIB:
  cpuSelector: 'hrDeviceType="1.3.6.1.2.1.25.3.1.3"',
  // memorySelector for metricsSources with HOST-RESOURCES-MIB, on devices without net-snmp's memory rows:
  memorySelector: 'hrStorageDescr!~".*(?i:(cache|buffer)).*", hrStorageType="1.3.6.1.2.1.25.2.1.2"',
  mikrotikMemorySelector: 'hrStorageDescr="main memory",hrStorageIndex="65536"',
  // ignore interface sensors
  ciscoTemperatureSelector: 'entSensorType="8", entPhysicalName!~".+(\\\\d+/\\\\d+(/\\\\d+)?).*"',

  // Alerts
  alertsNodeCPUHighUsageWarning: self.alertsCPUThresholdWarning,  // > percent
  alertsCPUThresholdWarning: 90,  // Deprecated, use alertsNodeCPUHighUsageWarning instead.

  alertsNodeMemoryUtilizationInfo: self.alertMemoryUsageThresholdCritical,  // > percent
  alertMemoryUsageThresholdCritical: 90,  // Deprecated, use alertsNodeMemoryUtilizationInfo instead.

  alertsInterfaceDropsWarning: 5,  // > percent of packets
  assert !std.objectHasAll(self, 'alertsPacketsDroppedPerSecThresholdWarning') :
         'alertsPacketsDroppedPerSecThresholdWarning is replaced by alertsInterfaceDropsWarning, a percent of the interface packets.',

  alertsInterfaceErrorsWarning: 1,  // > percent of packets
  assert !std.objectHasAll(self, 'alertsErrorsPerSecThresholdWarning') :
         'alertsErrorsPerSecThresholdWarning is replaced by alertsInterfaceErrorsWarning, a percent of the interface packets.',

  alertsInterfaceFCErrorsWarning: 0,  // > errors per second

  alertsExporterSlowScrapeInfo: self.alertsSlowScrapeThresholdInfo,  // > seconds
  alertsSlowScrapeThresholdInfo: 25,  // Deprecated, use alertsExporterSlowScrapeInfo instead.

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
      alerts: (import './signals/alerts.libsonnet')(this),
      exporter: (import './signals/exporter.libsonnet')(this),
      logs: (import './signals/logs.libsonnet')(this),
    },

  // logs lib related
  enableLokiLogs: true,
  logsFilteringSelector: 'job="syslog"',
  logsGroupLabels: this.groupLabels,
  logsInstanceLabels: this.instanceLabels,
  logsExtraFilters: '',
  extraLogLabels: ['sysname', 'syslog_app_name', 'level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
  customAllValue: '.*',  // Override this as desired. '.+' is a good option if you want to ensure a label is present

}
