// variables.libsonnet
local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(
    filteringSelector,
    groupLabels,
    instanceLabels,
    varMetric,
    enableLokiLogs=false,
  ): {
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
           + var.datasource.generalOptions.withLabel('Prometheus data source')
           + var.datasource.withRegex(''),
       },
       // Use on dashboards where multiple entities can be selected, like fleet dashboards
       multiInstance:
         [root.datasources.prometheus]
         + variablesFromLabels(groupLabels, instanceLabels, filteringSelector),
       // Use on dashboards where only single entity can be selected
       singleInstance:
         [root.datasources.prometheus]
         + variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=false),

       queriesSelector:
         '%s,%s' % [
           filteringSelector,
           utils.labelsToPromQLSelector(groupLabels + instanceLabels),
         ],
     }
     + if enableLokiLogs then self.withLokiLogs() else {},

  withLokiLogs(): {
    datasources+: {
      loki:
        var.datasource.new('datasource', 'loki')
        + var.datasource.generalOptions.withLabel('Loki data source')
        + var.datasource.withRegex(''),
        // + var.datasource.generalOptions.showOnDashboard.withNothing(),
    },

    multiInstance+: [self.datasources.loki],
    singleInstance+: [self.datasources.loki],
  },

}
