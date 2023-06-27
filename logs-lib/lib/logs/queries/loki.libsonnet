local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local utils = import 'utils.libsonnet';
{
  new(
    datasourceRegex,
    filterSelector,
    labels,
    formatParser,
  ): {
    local var = g.dashboard.variable,

    variables: {
      local this = self,
      local chainVarProto(chainVar) =
        var.query.new(chainVar.label)
        + var.query.withDatasourceFromVariable(this.datasource)
        +
        (
          if std.length(chainVar.chainSelector) > 0 then
            var.query.queryTypes.withLabelValues(
              chainVar.label,
              '{%s, %s}' % [
                filterSelector,
                chainVar.chainSelector,
              ]
            ) else
            // specific first variable case
            var.query.queryTypes.withLabelValues(
              chainVar.label,
              '{%s}' % [
                filterSelector,
              ]
            )
        )

        + var.query.selectionOptions.withIncludeAll(value=true, customAllValue='.*')
        + var.query.selectionOptions.withMulti()
        + var.query.withSort(i=1, type='alphabetical', asc=true, caseInsensitive=false),

      datasource:
        var.datasource.new('datasource', 'loki')
        + var.datasource.withRegex(datasourceRegex),

      regex_search:
        var.textbox.new('regex_search', default=''),

      toArray:
        [self.datasource] +
        [chainVarProto(chainVar) for chainVar in utils.chainLabels(labels)] +
        [self.regex_search],

      queriesSelector:
        '%s, %s' % [
          filterSelector,
          std.reverse(utils.chainLabels(labels))[0].chainSelector,
        ],
    },

    local lokiQuery = g.query.loki,

    logsTarget()::
      lokiQuery.new(
        datasource='$' + self.variables.datasource.name,
        expr=|||
          {%s} 
          |~ "$regex_search"
          %s
        ||| % [
          self.variables.queriesSelector,
          if formatParser != null then '| %s | __error__=``' % formatParser else '',
        ]

      ),

    logsVolumeTarget()::
      lokiQuery.new(
        datasource='$' + self.variables.datasource.name,
        expr=|||
          sum by (level) (count_over_time({%s} 
          |~ "$regex_search"
          %s
          [$__interval]))
        ||| % [
          self.variables.queriesSelector,
          if formatParser != null then '| %s | __error__=``' % formatParser else '',
        ]
      )
      + lokiQuery.withLegendFormat('{{ level }}'),
  },
}
