local utils = import '../utils.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local var = g.dashboard.variable;
function(
  datasourceName,
  datasourceRegex,
  filterSelector,
  labels,
)
  {
    local this = self,
    local variablesFromLabels(labels, filterSelector) =
      local chainVarProto(chainVar) =
        var.query.new(chainVar.label)
        + var.query.withDatasourceFromVariable(this.datasource)
        + var.query.queryTypes.withLabelValues(
          chainVar.label,
          '{%s}' % chainVar.chainSelector,
        )
        + var.query.selectionOptions.withIncludeAll(
          value=true,
          customAllValue='.*'
        )
        + var.query.selectionOptions.withMulti()
        + var.query.withSort(
          i=1,
          type='alphabetical',
          asc=true,
          caseInsensitive=false
        )
      ;
      [
        chainVarProto(chainVar)
        for chainVar in utils.chainLabels(labels, [filterSelector])
      ],

    datasource:
      var.datasource.new(datasourceName, 'loki')
      + var.datasource.withRegex(datasourceRegex),

    regex_search:
      var.textbox.new('regex_search', default=''),

    toArray:
      [self.datasource]
      + variablesFromLabels(labels, filterSelector)
      + [self.regex_search],

    queriesSelector:
      '%s,%s' % [
        filterSelector,
        utils.labelsToPromQLSelector(labels),
      ],
  }
