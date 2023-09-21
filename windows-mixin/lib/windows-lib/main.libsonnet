local dashboards = import './dashboards.libsonnet';
local datasources = import './datasources.libsonnet';
local g = import './g.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';
local commonlib = import 'common/main.libsonnet';

{

  // any modular library should inlcude as inputs:
  // 'prefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filterSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.

  new(
    prefix='',
    filterSelector,
    tags=[uid],
    uid,
    groupLabels=['job'],
    instanceLabels=['instance'],
  ): {

    local this = self,
    config: {
      ignoreVolumes: 'HarddiskVolume.*',
      groupLabels: groupLabels,
      instanceLabels: instanceLabels,
      filterSelector: filterSelector,
      tags: tags,
      uid: uid,
      prefix: prefix,
      enableLokiLogs: true,
    },

    variables: variables.new(this),

    targets: targets.new(this),

    annotations: {
                   reboot: commonlib.annotations.reboot.new(
                             title='Reboot',
                             target=this.targets.reboot,
                             instanceLabels=std.join(',', instanceLabels),
                           )
                           + commonlib.annotations.base.withTagKeys(std.join(',', groupLabels + instanceLabels + ['level'])),
                 }
                 +
                 if this.config.enableLokiLogs then
                   {
                     serviceFailed: commonlib.annotations.serviceFailed.new(
                                      title='Service failed',
                                      target=this.targets.serviceFailed,
                                    )
                                    + commonlib.annotations.base.withTagKeys(std.join(',', groupLabels + instanceLabels + ['level']))
                                    + commonlib.annotations.base.withTextFormat('{{message}}'),
                     criticalEvents: commonlib.annotations.fatal.new(
                                       title='Critical system event',
                                       target=this.targets.criticalEvents,
                                     )
                                     + commonlib.annotations.base.withTagKeys(std.join(',', groupLabels + instanceLabels + ['level']))
                                     + commonlib.annotations.base.withTextFormat('{{message}}'),
                   } else {},

    // common links here
    links: {
      local link = g.dashboard.link,
      backToFleet:
        link.link.new('Back to Windows fleet', '/d/' + this.dashboards.fleet.uid)
        + link.link.options.withKeepTime(true),
      backToOverview:
        link.link.new('Back to Windows overview', '/d/' + this.dashboards.overview.uid)
        + link.link.options.withKeepTime(true),
      otherDashboards:
        link.dashboards.new('All Windows dashboards', tags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),
    },

    panels: panels.new(
      this
    ),

    dashboards: dashboards.new(
      this
    ),

    alerts: {},
    recordingRules: {},
  },

}
