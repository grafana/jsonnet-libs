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
      local nodeNameLabel = this.config.nodeNameLabel,
      local testNameLabel = this.config.testNameLabel,

      local varMetric = 'catchpoint_any_error',
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
      datasources: {
        prometheus:
          var.datasource.new('prometheus_datasource', 'prometheus')
          + var.datasource.generalOptions.withLabel('Data source')
          + var.datasource.withRegex(''),
      },

      // Use on dashboards where multiple entities can be selected, like fleet dashboards
      multiInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector),
      // Use on dashboards where only single entity can be selected, like drill-down dashboards
      singleInstance:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=false),
      // Use on dashboards where multiple entities can be selected, like fleet dashboards
      overviewVariables:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels + testNameLabel, filteringSelector, multiInstance=true),

      testNameVariable:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=true) + [testNameLabel],

      nodeNameVariable:
        [root.datasources.prometheus]
        + variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=true) + [nodeNameLabel],

      queriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels),
        ],

      pureTestNameSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + instanceLabels + testNameLabel),
        ],

      testNameSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + instanceLabels + testNameLabel),
        ],

      nodeNameSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + testNameLabel),
        ],

      queriesGroupSelectorAdvanced:
        '%s' % [
          utils.labelsToPromQLSelectorAdvanced(groupLabels),
        ],
    },
}
