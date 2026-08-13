local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
local var = g.dashboard.variable;

// Standard chained variables from commonlib, plus the two Velero-specific
// selectors the dashboards need.
{
  new(this, varMetric):
    local config = this.config;
    local base = commonlib.variables.new(
      filteringSelector=config.filteringSelector,
      groupLabels=config.groupLabels,
      instanceLabels=config.instanceLabels,
      varMetric=varMetric,
      customAllValue='.+',
      enableLokiLogs=config.enableLokiLogs,
    );
    // the cluster view compares whole clusters, so it selects on group labels only
    local clusterBase = commonlib.variables.new(
      filteringSelector=config.filteringSelector,
      groupLabels=config.groupLabels,
      instanceLabels=[],
      varMetric=varMetric,
      customAllValue='.+',
      enableLokiLogs=config.enableLokiLogs,
    );

    base {
      local topClusterCount =
        var.custom.new('top_cluster_count', values=[2, 4, 6, 8, 10])
        + var.custom.generalOptions.withLabel('Top cluster count')
        + var.custom.generalOptions.withDescription(
          'This variable allows for modification of top cluster value.'
        ),

      local schedule =
        var.query.new('schedule')
        + var.query.withDatasourceFromVariable(base.datasources.prometheus)
        + var.query.queryTypes.withLabelValues(
          'schedule',
          'velero_backup_attempt_total{%s}' % base.queriesSelector,
        )
        + var.query.generalOptions.withLabel('Schedule')
        + var.query.selectionOptions.withIncludeAll(value=true, customAllValue='.*')
        + var.query.selectionOptions.withMulti(true)
        + var.query.refresh.onTime()
        + var.query.withSort(i=1, type='alphabetical', asc=true, caseInsensitive=false),

      clusterVariables: clusterBase.multiInstance + [topClusterCount],
      overviewVariables: base.singleInstance + [schedule],

      // alertlist filters on the group labels only
      alertInstanceSelector: utils.labelsToPromQLSelectorAdvanced(config.groupLabels),
    },
}
