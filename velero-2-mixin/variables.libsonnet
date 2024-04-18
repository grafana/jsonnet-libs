local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

// Generates chained variables to use on on all dashboards
{
  new(this, varMetric):
    {
      local filteringSelector = this.config.filteringSelector,
      local groupLabels = this.config.groupLabels,
      local instanceLabels = this.config.instanceLabels,
      local scheduleLabel = 'schedule',
      local groupVarMetric = 'velero_backup_attempt_total',
      local topClusterSelector =
        var.custom.new(
          'top_cluster_count',
          values=[2, 4, 6, 8, 10],
        )
        + var.custom.generalOptions.withDescription(
          'This variable allows for modification of top cluster value.'
        )
        + var.custom.generalOptions.withLabel('Top cluster count'),
      local root = self,
      local variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=true) =
        local chainVarProto(index, chainVar) =
          var.query.new(chainVar.label)
          + var.query.withDatasourceFromVariable(root.datasources.prometheus)
          + var.query.queryTypes.withLabelValues(
            chainVar.label,
            '%s{%s}' % [varMetric, chainVar.chainSelector],
          )
          + var.query.generalOptions.withLabel(utils.toSentenceCase(chainVar.label))
          + var.query.selectionOptions.withIncludeAll(
            value=if (!multiInstance && std.member(instanceLabels, chainVar.label)) then false else true,
            customAllValue='.+'
          )
          + var.query.selectionOptions.withMulti(
            if (!multiInstance && std.member(instanceLabels, chainVar.label)) then false else true,
          )
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false
          );
        std.mapWithIndex(chainVarProto, utils.chainLabels(groupLabels + instanceLabels, [filteringSelector])),

      local groupVariablesFromLabels(groupLabels) =
        local chainVarProto(index, chainVar) =
          var.query.new(chainVar.label)
          + var.query.withDatasourceFromVariable(root.datasources.prometheus)
          + var.query.queryTypes.withLabelValues(
            chainVar.label,
            '%s{%s}' % [groupVarMetric, chainVar.chainSelector],
          )
          + var.query.generalOptions.withLabel(utils.toSentenceCase(chainVar.label))
          + var.query.selectionOptions.withIncludeAll(
            value=false,
          )
          + var.query.selectionOptions.withMulti(
            false,
          )
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false,
          );
        std.mapWithIndex(chainVarProto, utils.chainLabels(groupLabels, [])),
      local createOverviewVariable(name, displayName, metric, selector) =
        local variable =
          var.query.new(name)
          + var.query.withDatasourceFromVariable(root.datasources.prometheus)
          + var.query.queryTypes.withLabelValues(
            'schedule',
            '%s{%s}' % [metric, selector],
          )
          + var.query.generalOptions.withLabel(displayName)
          + var.query.selectionOptions.withIncludeAll(
            value=true,
            customAllValue='.*',
          )
          + var.query.selectionOptions.withMulti(
            true,
          )
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false,
          );
        [variable],
      datasources: {
        prometheus:
          var.datasource.new('prometheus_datasource', 'prometheus')
          + var.datasource.generalOptions.withLabel('Prometheus data source')
          + var.datasource.withRegex(''),
        loki:
          var.datasource.new('loki_datasource', 'loki')
          + var.datasource.generalOptions.withLabel('Loki data source')
          + var.datasource.withRegex('')
          // hide by default (used for annotations)
          + var.datasource.generalOptions.showOnDashboard.withNothing(),
      },
      // Use on dashboards where multiple entities can be selected, like fleet dashboards
      multiInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector),
      multiCluster:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, [], filteringSelector),
      // Use on dashboards where only single entity can be selected, like drill-down dashboards
      singleInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=false),

      queriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + instanceLabels + ['schedule']),
        ],
      overviewVariables:
        [root.datasources.prometheus]
        + groupVariablesFromLabels(groupLabels)
        + groupVariablesFromLabels(instanceLabels)
        + createOverviewVariable(scheduleLabel, 'Schedule', groupVarMetric, 'job=~"$job", cluster=~"$cluster", instance=~"$instance"'),

      queriesGroupSelectorAdvanced:
        '%s' % [
          utils.labelsToPromQLSelectorAdvanced(groupLabels),
        ],

      clusterVariableSelectors:
        [root.datasources.prometheus] + variablesFromLabels(groupLabels, [], filteringSelector) + [topClusterSelector],

      clusterQuerySelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels),
        ],
    }
    + if this.config.enableLokiLogs then self.withLokiLogs(this) else {},
  withLokiLogs(this): {
    multiInstance+: [this.grafana.variables.datasources.loki],
    singleInstance+: [this.grafana.variables.datasources.loki],
  },
}
