local dashboards = import './dashboards.libsonnet';
local panels = import './panels.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';
local g = import './g.libsonnet';
local commonlib = import 'common/main.libsonnet';

{

  // any modular library should inlcude as inputs:
  // 'prefix' - Use as prefix for all Dashboards and (optional) rule groups
  // 'filterSelector' - Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  // 'groupLabels' - one or more labels that can be used to identify 'group' of instances. In simple cases, can be 'job' or 'cluster'.
  // 'instanceLabels' - one or more labels that can be used to identify single entity of instances. In simple cases, can be 'instance' or 'pod'.

  new(
    prefix="",
    filterSelector,
    tags=[uid],
    uid,
    // filterSelector,
    groupLabels=['job'],
    instanceLabels=['instance']
    // datasourceRegex,
    // datasourceName='datasource',
    // formatParser=null,
    // showLogsVolume=true,
    // logsVolumeGroupBy='level',
    // extraFilters='',
  ): {

    local this = self,
    variables: variables.new(
    //   datasourceName,
    //   datasourceRegex,
      filterSelector,
      groupLabels,
      instanceLabels,
    ),

    targets: targets.new(
      this.variables,
    ),

    annotations: {
      reboot: commonlib.annotations.reboot.new(
      title="Reboot",
      target=this.targets.reboot,
      instanceLabels=std.join(",", instanceLabels),
      ),
    },

    // common links here
    links: {
      local link = g.dashboard.link,
      backToFleet:
        link.link.new('Back to Windows fleet', "/d/" + this.dashboards.fleet.uid)
        + link.link.options.withKeepTime(true),
      backToOverview:
        link.link.new('Back to Windows overview', "/d/" + this.dashboards.overview.uid)
        + link.link.options.withKeepTime(true),
      otherDashboards:  
        link.dashboards.new('All Windows dashboards', tags)
        + link.dashboards.options.withIncludeVars(true)
        + link.dashboards.options.withKeepTime(true)
        + link.dashboards.options.withAsDropdown(true),
    },

    panels: panels.new(
    //   this.targets.logsVolumeTarget,
    //   this.targets.logsTarget,
    ),

    dashboards: dashboards.new(
      prefix,
      this.links,
      tags,
      uid,
      // this.panels,
      this.variables,
      this.annotations,
    ),

    alerts: {},
    recordingRules: {},
  },

}