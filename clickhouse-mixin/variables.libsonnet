local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

// Generates chained variables to use on all dashboards
{
  new(this, varMetric):
    {
      local filteringSelector = this.config.filteringSelector,
      local groupLabels = this.config.groupLabels,
      local instanceLabels = this.config.instanceLabels,
      local nodeNameLabel = if std.objectHas(this.config, 'nodeNameLabel') then this.config.nodeNameLabel else ['node'],
      local testNameLabel = if std.objectHas(this.config, 'testNameLabel') then this.config.testNameLabel else ['test'],

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
            value=true,
            customAllValue='.+'
          )
          + var.query.selectionOptions.withMulti(true)
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false
          );
        std.mapWithIndex(chainVarProto, utils.chainLabels(groupLabels + instanceLabels, [filteringSelector])),
      datasources: {
        prometheus:
          var.datasource.new('prometheus_datasource', 'prometheus')
          + var.datasource.generalOptions.withLabel('Prometheus data source')
          + var.datasource.withRegex(''),
        loki:
          var.datasource.new('loki_datasource', 'loki')
          + var.datasource.generalOptions.withLabel('Loki data source')
          + var.datasource.withRegex(''),
      },

      multiInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector),

      singleInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=false),

      overviewVariables:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels + testNameLabel, filteringSelector, multiInstance=true),

      queriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels),
        ],

      testNameSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + instanceLabels + testNameLabel),
        ],

      nodeNameSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + instanceLabels + nodeNameLabel),
        ],

    },
}
