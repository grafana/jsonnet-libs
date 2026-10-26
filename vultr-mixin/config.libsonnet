local commonlib = import 'common-lib/common/main.libsonnet';

{
  local this = self,
  dashboardTags: [self.uid + '-mixin'],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: commonlib.dashboards.defaultTimezone,
  dashboardRefresh: '1m',
  dashboardNamePrefix: 'Vultr',
  uid: 'vultr',

  // Filtering and labels. Vultr attaches uuid, label, hostname, region, plan and os
  // to every instance series; label is the instance name shown in the Vultr console.
  filteringSelector: '',
  groupLabels: ['job'],
  instanceLabels: ['region', 'label'],

  // Metrics source
  metricsSource: ['prometheus'],

  customAllValue: '.+',

  // Signals
  signals+: {
    instance: (import './signals/instance.libsonnet')(this),
  },

  // Feature flags
  enableLokiLogs: false,

  // Alert thresholds
  alertsCPUUsageWarning: 90,  // %
  alertsBandwidthUsageWarning: 80,  // % of the billing period allowance
  alertsBandwidthUsageCritical: 95,  // % of the billing period allowance
  alertsGPUTemperatureWarning: 85,  // °C
}
