local g = import './g.libsonnet';
local var = g.dashboard.variable;
local utils = import '../utils.libsonnet';

function(
  datasourceName,
  datasourceLabel,
  datasourceRegex,
  filterSelector,
  labels,
  customAllValue,
  adHocEnabled,
  adHocLabels,
)
  {
    // strip trailing or starting comma if present that are not accepted in LoqQL
    // starting comma can be present in case of concatenation of empty filteringSelector with some extra selectors.
    local _filteringSelector = std.stripChars(std.stripChars(filterSelector, ' '), ','),
    local this = self,
    local variablesFromLabels(labels, filterSelector) =
      local chainVarProto(chainVar) =
        var.query.new(chainVar.label)
        + var.query.withDatasourceFromVariable(this.datasource)
        + var.query.generalOptions.withLabel(utils.toSentenceCase(chainVar.label))
        + var.query.queryTypes.withLabelValues(
          chainVar.label,
          '{%s}' % chainVar.chainSelector,
        )
        + var.query.selectionOptions.withIncludeAll(
          value=true,
          customAllValue=customAllValue,
        )
        + var.query.selectionOptions.withMulti()
        + var.query.refresh.onTime()
        + var.query.withSort(
          i=1,
          type='alphabetical',
          asc=true,
          caseInsensitive=false
        )
      ;
      [
        chainVarProto(chainVar)
        for chainVar in utils.chainLabels(labels, [_filteringSelector])
      ],

    datasource:
      var.datasource.new(datasourceName, 'loki')
      + var.datasource.withRegex(datasourceRegex)
      + var.query.generalOptions.withLabel(datasourceLabel),

    regexSearch:
      var.textbox.new('regex_search', default='')
      + var.query.generalOptions.withLabel('Regex search'),

    adHoc:
      var.adhoc.new('adhoc', 'loki', '${' + self.datasource.name + '}')
      + var.adhoc.generalOptions.withLabel('Adhoc filters')
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
    toArray:
      [self.datasource]
      + variablesFromLabels(labels, _filteringSelector)
      + [self.regexSearch]
      + (if adHocEnabled then [self.adHoc] else []),

    queriesSelector:
      std.join(
        ',',
        std.filter(function(x) std.length(x) > 0, [
          _filteringSelector,
          utils.labelsToPromQLSelector(labels),
        ])
      ),
  }
