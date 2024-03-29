// variables.libsonnet
local g = import './g.libsonnet';
local var = g.dashboard.variable;
local utils = import './utils.libsonnet';

{
  new(
    varMetric,
    filteringSelector,
    groupLabels,
    instanceLabels,
  ): {

    local root = self,
    // local varMetric = varMetric,
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
        var.datasource.new('datasource', 'prometheus')
        + var.datasource.generalOptions.withLabel('Data source'),
      loki:
        var.datasource.new('loki_datasource', 'loki')
        + var.datasource.generalOptions.withLabel('Loki data source')
        + var.datasource.generalOptions.showOnDashboard.withNothing(),
    },
    multiInstance:
      [root.datasources.prometheus]
      + variablesFromLabels(groupLabels, instanceLabels, filteringSelector),
    singleInstance:
      [root.datasources.prometheus]
      + variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=false),

    // add to all queries on all dashboards
    queriesSelector:
      '%s,%s' % [
        filteringSelector,
        utils.labelsToPromQLSelector(groupLabels + instanceLabels),
      ],
  },
}
