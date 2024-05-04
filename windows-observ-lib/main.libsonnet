local alerts = import './alerts.libsonnet';
local dashboards = import './dashboards.libsonnet';
local datasources = import './datasources.libsonnet';
local g = import './g.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(
    filteringSelector,
    groupLabels=['job'],
    instanceLabels=['instance'],
    dashboardNamePrefix='',
    dashboardTags=[uid],
    uid,
  ): {

    local this = self,
    config: {
      // any modular library should include as inputs:
      // 'dashboardNamePrefix' - Use as prefix for all Dashboards and (optional) rule groups
      // 'filteringSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
      // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
      // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.
      // 'uid' - UID to prefix all dashboards original uids
      groupLabels: groupLabels,
      instanceLabels: instanceLabels,
      filteringSelector: filteringSelector,
      dashboardTags: dashboardTags,
      uid: uid,
      dashboardNamePrefix: dashboardNamePrefix,

      // optional
      ignoreVolumes: 'HarddiskVolume.*',
      alertsCPUThresholdWarning: '90',
      alertMemoryUsageThresholdCritical: '90',
      alertDiskUsageThresholdCritical: '90',
      dashboardPeriod: 'now-1h',
      dashboardTimezone: 'default',
      dashboardRefresh: '1m',

      // optional Windows AD
      alertsHighPendingReplicationOperations: 50,  // count
      alertsHighReplicationSyncRequestFailures: 0,  // count
      alertsHighPasswordChanges: 25,  // count
      alertsMetricsDownJobName: 'integrations/windows_exporter',
      enableADDashboard: false,

      // logs lib related
      enableLokiLogs: true,
      extraLogLabels: ['channel', 'source', 'keywords', 'level'],
      logsVolumeGroupBy: 'level',
      showLogsVolume: true,
      logsExtraFilters:
        |||
          | label_format timestamp="{{__timestamp__}}"
          | drop channel_extracted,source_extracted,computer_extracted,level_extracted,keywords_extracted
          | line_format `{{ if eq "[[instance]]" ".*" }}{{ alignLeft 25 .instance}}|{{end}}{{alignLeft 12 .channel }}| {{ alignLeft 25 .source}}| {{ .message }}`
        |||,
    },
    grafana: {
      variables: commonlib.variables.new(
        filteringSelector=this.config.filteringSelector,
        groupLabels=this.config.groupLabels,
        instanceLabels=this.config.instanceLabels,
        varMetric='windows_os_info',
        customAllValue='.+',
        enableLokiLogs=this.config.enableLokiLogs,
      ),
      targets: targets.new(this),
      annotations:
        {
          reboot: commonlib.annotations.reboot.new(
                    title='Reboot',
                    target=this.grafana.targets.reboot,
                    instanceLabels=std.join(',', instanceLabels),
                  )
                  + commonlib.annotations.base.withTagKeys(std.join(',', this.config.groupLabels + this.config.instanceLabels)),
        }
        +
        if
          this.config.enableLokiLogs
        then
          {
            serviceFailed: commonlib.annotations.serviceFailed.new(
                             title='Service failed',
                             target=this.grafana.targets.serviceFailed,
                           )
                           + commonlib.annotations.base.withTagKeys(std.join(',', this.config.groupLabels + this.config.instanceLabels + ['level']))
                           + commonlib.annotations.base.withTextFormat('{{message}}'),
            criticalEvents: commonlib.annotations.fatal.new(
                              title='Critical system event',
                              target=this.grafana.targets.criticalEvents,
                            )
                            + commonlib.annotations.base.withTagKeys(std.join(',', this.config.groupLabels + this.config.instanceLabels + ['level']))
                            + commonlib.annotations.base.withTextFormat('{{message}}'),
          }
        else
          {},
      // common links here
      links: {
        local link = g.dashboard.link,
        backToFleet:
          link.link.new('Back to Windows fleet', '/d/' + this.grafana.dashboards.fleet.uid)
          + link.link.options.withKeepTime(true),
        backToOverview:
          link.link.new('Back to Windows overview', '/d/' + this.grafana.dashboards.overview.uid)
          + link.link.options.withKeepTime(true),
        otherDashboards:
          link.dashboards.new('All Windows dashboards', this.config.dashboardTags)
          + link.dashboards.options.withIncludeVars(true)
          + link.dashboards.options.withKeepTime(true)
          + link.dashboards.options.withAsDropdown(true),
      },

      panels: panels.new(this),
      dashboards: dashboards.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },

  },

}
