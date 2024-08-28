local g = import '../g.libsonnet';
local var = g.dashboard.variable;
local utils = import '../utils.libsonnet';

{
  new(
    filteringSelector,
    groupLabels,
    instanceLabels,
    varMetric='up',
    enableLokiLogs=false,
    customAllValue='.+',
    prometheusDatasourceName='datasource',
    prometheusDatasourceLabel='Data source',
  ): {
       local varMetricTemplate =
         if std.type(varMetric) == 'array'
         then '{__name__=~"%s",%%s}' % std.join('|', std.uniq(varMetric))
         else if std.type(varMetric) == 'string'
         then '%s{%%s}' % varMetric
         else error ('varMetric must be array or string'),
       local root = self,
       local variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=true) =
         local chainVarProto(index, chainVar) =
           var.query.new(chainVar.label)
           + var.query.withDatasourceFromVariable(root.datasources.prometheus)
           + var.query.queryTypes.withLabelValues(
             chainVar.label,
             varMetricTemplate % [chainVar.chainSelector],
           )
           + var.query.generalOptions.withLabel(utils.toSentenceCase(chainVar.label))
           + var.query.selectionOptions.withIncludeAll(
             value=if (!multiInstance && std.member(instanceLabels, chainVar.label)) then false else true,
             customAllValue=customAllValue,
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
           var.datasource.new(prometheusDatasourceName, 'prometheus')
           + var.datasource.generalOptions.withLabel(prometheusDatasourceLabel)
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
       queriesSelectorAdvancedSyntax:
         '%s' % [
           utils.labelsToPromQLSelectorAdvanced(groupLabels + instanceLabels),
         ],
       queriesSelector:
         '%s,%s' % [
           filteringSelector,
           utils.labelsToPromQLSelector(groupLabels + instanceLabels),
         ],

     }
     + if enableLokiLogs then self.withLokiLogs() else {},

  withLokiLogs(
    lokiDatasourceName='loki_datasource',
    lokiDatasourceLabel='Loki data source',
  ): {
    datasources+: {
      loki:
        var.datasource.new(lokiDatasourceName, 'loki')
        + var.datasource.generalOptions.withLabel(lokiDatasourceLabel)
        + var.datasource.withRegex('')
        + var.datasource.generalOptions.showOnDashboard.withNothing(),
    },

    multiInstance+: [self.datasources.loki],
    singleInstance+: [self.datasources.loki],
  },

}
