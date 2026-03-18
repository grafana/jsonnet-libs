local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this, varMetric):
    {
      local filteringSelector = this.config.filteringSelector,
      local groupLabels = this.config.groupLabels,
      local instanceLabels = this.config.instanceLabels,
      local pureInstanceLabels = this.config.pureInstanceLabels,
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
        std.mapWithIndex(chainVarProto, utils.chainLabels(groupLabels + instanceLabels, if std.length(filteringSelector) > 0 then [filteringSelector] else [])),
      datasources: {
        prometheus:
          var.datasource.new('prometheus_datasource', 'prometheus')
          + var.datasource.generalOptions.withLabel('Prometheus data source')
          + var.datasource.withRegex(''),
      },
      multiInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector),
      singleInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, pureInstanceLabels, filteringSelector, multiInstance=false),
      queriesSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels + instanceLabels),
          filteringSelector,
        ],
      queriesGroupSelectorAdvanced:
        '%s' % [
          utils.labelsToPromQLSelectorAdvanced(groupLabels),
        ],
      clusterQuerySelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels),
          filteringSelector,
        ],
      instanceQueriesSelector:
        '%s,%s' % [
          utils.labelsToPromQLSelector(groupLabels + pureInstanceLabels),
          filteringSelector,
        ],
    },
}
