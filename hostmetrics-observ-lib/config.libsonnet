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
  filteringSelector: '',  // set to apply static filters to all queries and alerts, i.e. job="integrations/linux-hostmetrics"
  dashboardTags: ['hostmetrics'],
  uid: 'hostmetrics',
  dashboardNamePrefix: 'Hostmetrics / ',
  dashboardPeriod: 'now-1h',
  dashboardTimezone: commonlib.dashboards.defaultTimezone,
  dashboardRefresh: '1m',
  customAllValue: '.*',

  // Metric names as stored in Prometheus-compatible backends after OTLP ingestion.
  // 'otel' - semantic convention names without unit suffixes, i.e. system_cpu_utilization.
  // 'otel_with_suffixes' - names with unit and type suffixes, i.e. system_cpu_utilization_ratio.
  // The default works with either. Set the one your backend uses for simpler queries.
  metricsSource: ['otel', 'otel_with_suffixes'],

  // Match the scrapers enabled in the hostmetrics receiver. Panels for disabled scrapers are not rendered.
  enablePagingScraper: true,
  enableNetworkScraper: true,
  // The receiver's collection_interval, used as the minimum step of time series queries.
  minInterval: '1m',

  // Extra label matchers added to disk, filesystem and network queries in dashboards and alerts, e.g.
  // 'device!~"loop.*"' or 'type!="tmpfs"'. They only hide series from queries; devices excluded in the
  // hostmetrics receiver's config are never collected at all. The defaults match everything.
  diskDeviceSelector: 'device!=""',
  filesystemSelector: 'type!=""',
  filesystemMountpointSelector: 'mountpoint!=""',
  networkInterfaceSelector: 'device!=""',

  // Loki logs dashboard, for logs sent over OTLP. Loki labels them from resource attributes:
  // service_name and service_instance_id where the metrics have job and instance.
  enableLokiLogs: true,
  logsGroupLabels: ['service_name'],
  logsInstanceLabels: ['service_instance_id'],
  extraLogLabels: [],
  logsVolumeGroupBy: 'detected_level',
  showLogsVolume: true,
  logsFilteringSelector: 'service_name!=""',
  logsExtraFilters:
    |||
      | label_format timestamp="{{__timestamp__}}"
      | line_format `{{ if eq "[[instance]]" ".*" }}{{alignLeft 25 .service_instance_id}}|{{end}} {{__line__}}`
    |||,

  // Alerts thresholds
  alertsCPUHighUsageThreshold: 90,  // %
  alertsMemoryHighUtilizationThreshold: 90,  // %
  alertsDiskSpaceLowThresholdWarning: 95,  // % used
  alertsDiskSpaceLowThresholdCritical: 97,  // % used
  alertsSystemSaturationPerCoreThreshold: 2,  // 5m load average relative to logical core count
  alertsInodesLowThresholdWarning: 95,  // % used
  alertsInodesLowThresholdCritical: 97,  // % used
  alertsDiskIOSaturationThreshold: 10,  // average I/O queue length
  alertsNetworkErrorsThreshold: 1,  // % of packets
  alertsConntrackHighUsageThreshold: 75,  // % of the conntrack table
  alertsMemoryMajorPageFaultsThreshold: 500,  // per second
  alertsProcessesHighThreshold: 400,  // running processes
  alertsHostRebootedThreshold: 600,  // seconds of uptime
  alertsHostDownWindow: '5m',  // silence before HostmetricsHostDown fires
  alertsHostDownLookback: '30m',  // how far back it looks for hosts: it resolves once a host has been silent this long

  // Alerts severities. HostmetricsDiskSpaceLow and HostmetricsInodesLow have no severity setting: each has a
  // warning rule and a critical rule, tuned with the thresholds above.
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
