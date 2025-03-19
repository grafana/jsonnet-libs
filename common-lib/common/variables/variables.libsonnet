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
    prometheusDatasourceName=if enableLokiLogs then 'prometheus_datasource' else 'datasource',
    prometheusDatasourceLabel=if enableLokiLogs then 'Prometheus data source' else 'Data source',
    adHocEnabled=false,
    adHocLabels=[],
  ): {
       // strip trailing or starting comma if present:
       // while trailing comma is accepted in PromQL expressions, starting comma is not.
       // starting comma can be present in case of concatenation of empty filteringSelector with some extra selectors.
       local _filteringSelector = std.stripChars(std.stripChars(filteringSelector, ' '), ','),

       local varMetricTemplate(varMetric, chainSelector) =
         // check if chainSelector is not empty string (case when filtering selector is empty):
         if std.type(varMetric) == 'array' && chainSelector != ''
         then '{__name__=~"%s",%s}' % [std.join('|', std.uniq(varMetric)), chainSelector]
         else if std.type(varMetric) == 'array' && chainSelector == ''
         then '{__name__=~"%s"}' % std.join('|', std.uniq(varMetric))
         else if std.type(varMetric) == 'string'
         then '%s{%s}' % [varMetric, chainSelector]
         else error ('varMetric must be array or string'),

       local root = self,
       local variablesFromLabels(groupLabels, instanceLabels, filteringSelector, multiInstance=true) =
         local chainVarProto(index, chainVar) =
           var.query.new(chainVar.label)
           + var.query.withDatasourceFromVariable(root.datasources.prometheus)
           + var.query.queryTypes.withLabelValues(
             chainVar.label,
             varMetricTemplate(varMetric, chainVar.chainSelector),
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
         std.mapWithIndex(chainVarProto, utils.chainLabels(groupLabels + instanceLabels, if std.length(filteringSelector) > 0 then [filteringSelector] else [])),
       datasources: {
         prometheus:
           var.datasource.new(prometheusDatasourceName, 'prometheus')
           + var.datasource.generalOptions.withLabel(prometheusDatasourceLabel)
           + var.datasource.withRegex(''),
       },
       adHoc:
         var.adhoc.new('adhoc', 'prometheus', '${' + root.datasources.prometheus.name + '}')
         + var.adhoc.generalOptions.withLabel('Ad hoc filters')
         + var.adhoc.generalOptions.withDescription('Add additional filters')
         + (if std.length(adHocLabels) > 0 then {
              defaultKeys: [
                {
                  text: l,
                  value: l,
                }
                for l in adHocLabels
              ],
            } else {}),

       // Use on dashboards where multiple entities can be selected, like fleet dashboards
       multiInstance:
         [root.datasources.prometheus]
         + variablesFromLabels(groupLabels, instanceLabels, _filteringSelector)
         + (if adHocEnabled then [self.adHoc] else []),
       // Use on dashboards where only single entity can be selected
       singleInstance:
         [root.datasources.prometheus]
         + variablesFromLabels(groupLabels, instanceLabels, _filteringSelector, multiInstance=false)
         + (if adHocEnabled then [self.adHoc] else []),
       queriesSelectorAdvancedSyntax:
         std.join(
           ',',
           std.filter(function(x) std.length(x) > 0, [
             _filteringSelector,
             utils.labelsToPromQLSelectorAdvanced(groupLabels + instanceLabels),
           ])
         ),
       queriesSelector:
         std.join(
           ',',
           std.filter(function(x) std.length(x) > 0, [
             _filteringSelector,
             utils.labelsToPromQLSelector(groupLabels + instanceLabels),
           ])
         ),

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
