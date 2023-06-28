local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local utils = import 'utils.libsonnet';
local var = g.dashboard.variable;
function(
  datasourceRegex,
  filterSelector,
  labels,
)
  {
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
      '%s,%s' % [
        filterSelector,
        utils.labelsToPromQLSelector(labels),
      ],
  }
