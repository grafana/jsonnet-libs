local commonlib = import 'common-lib/common/main.libsonnet';
{
  local this = self,
  // any modular library should include as inputs:
  // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
  // 'uid' - UID to prefix all dashboards original uids
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  filteringSelector: 'job!=""',  // set to apply static filters to all queries and alerts, i.e. job="integrations/linux-hostmetrics"
  dashboardTags: ['hostmetrics'],
  uid: 'hostmetrics',
  dashboardNamePrefix: 'Hostmetrics / ',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: commonlib.dashboards.defaultTimezone,
  dashboardRefresh: '1m',
  customAllValue: '.+',

  // Metric names as stored in Prometheus-compatible backends after OTLP ingestion.
  // 'otel' - semantic convention names without unit suffixes, i.e. system_cpu_utilization.
  // 'otel_with_suffixes' - names with unit and type suffixes, i.e. system_cpu_utilization_ratio.
  // The default works with either. Set the one your backend uses for simpler queries.
  metricsSource: ['otel', 'otel_with_suffixes'],

  // Match the scrapers enabled in the hostmetrics receiver. Panels for disabled scrapers are not rendered.
  enablePagingScraper: true,
  enableNetworkScraper: true,

  // Extra label matchers added to disk, filesystem and network queries in dashboards and alerts, e.g.
  // 'device!~"loop.*"' or 'type!="tmpfs"'. They only hide series from queries; devices excluded in the
  // hostmetrics receiver's config are never collected at all. The defaults match everything.
  diskDeviceSelector: 'device!=""',
  filesystemSelector: 'type!=""',
  filesystemMountpointSelector: 'mountpoint!=""',
  networkInterfaceSelector: 'device!=""',

  // Loki logs dashboard, for logs collected with the same job and instance labels.
  // Logs sent over OTLP are labeled from resource attributes instead, i.e. service_name and
  // service_instance_id: set the logs selector and labels to match.
  enableLokiLogs: false,
  logsGroupLabels: self.groupLabels,
  logsInstanceLabels: self.instanceLabels,
  extraLogLabels: ['transport', 'unit', 'level'],
  logsVolumeGroupBy: 'level',
  showLogsVolume: true,
  logsFilteringSelector: self.filteringSelector,
  logsExtraFilters:
    |||
      | label_format timestamp="{{__timestamp__}}"
      | line_format `{{ if eq "[[instance]]" ".*" }}{{alignLeft 25 .instance}}|{{alignLeft 25 .unit}}|{{else}}{{alignLeft 25 .unit}}|{{end}} {{__line__}}`
    |||,

  // alerts thresholds
  alertsCPUHighUsageThreshold: 90,  // %
  alertsMemoryHighUtilizationThreshold: 90,  // %
  alertsDiskSpaceLowThresholdWarning: 95,  // %
  alertsDiskSpaceLowThresholdCritical: 97,  // %
  alertsSystemSaturationPerCoreThreshold: 2,  // 5m load average relative to logical core count
  alertsInodesLowThresholdWarning: 95,  // %
  alertsInodesLowThresholdCritical: 97,  // %
  alertsDiskIOSaturationThreshold: 10,  // average I/O queue length
  alertsNetworkErrorsThreshold: 1,  // % of packets
  alertsConntrackHighUsageThreshold: 75,  // % of the conntrack table
  alertsMemoryMajorPageFaultsThreshold: 500,  // per second
  alertsProcessesHighThreshold: 400,  // running processes
  alertsHostRebootedThreshold: 600,  // seconds of uptime
  alertsHostDownWindow: '10m',

  // alerts severities. HostmetricsDiskSpaceLow and HostmetricsInodesLow have a warning and a critical rule: tune
  // them with their thresholds.
  alertsHostDownSeverity: 'critical',
  alertsCPUHighUsageSeverity: 'warning',
  alertsMemoryHighUtilizationSeverity: 'warning',
  alertsSystemSaturationSeverity: 'warning',
  alertsDiskIOSaturationSeverity: 'warning',
  alertsNetworkErrorsSeverity: 'warning',
  alertsConntrackHighUsageSeverity: 'warning',
  alertsMemoryMajorPageFaultsSeverity: 'warning',
  alertsProcessesHighSeverity: 'warning',
  alertsHostRebootedSeverity: 'info',
  // How long alerts keep firing after the condition clears, so short dips don't resolve and re-fire them.
  alertsKeepFiringFor: '5m',

  signals+: {
    host: (import './signals/host.libsonnet')(this),
    cpu: (import './signals/cpu.libsonnet')(this),
    memory: (import './signals/memory.libsonnet')(this),
    disk: (import './signals/disk.libsonnet')(this),
    filesystem: (import './signals/filesystem.libsonnet')(this),
    network: (import './signals/network.libsonnet')(this),
  },
}
