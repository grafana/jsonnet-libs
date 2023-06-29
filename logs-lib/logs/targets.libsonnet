local utils = import '../utils.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local lokiQuery = g.query.loki;
function(
  variables,
  formatParser,
) {

  formatParser:: if formatParser != null then '| %s | __error__=``' % formatParser else '',
  logsTarget::
    lokiQuery.new(
      datasource='$' + variables.datasource.name,
      expr=|||
        {%s} 
        |~ "$regex_search"
        %s
      ||| % [
        variables.queriesSelector,
        self.formatParser,
      ]
    ),

  logsVolumeTarget::
    lokiQuery.new(
      datasource='$' + variables.datasource.name,
      expr=|||
        sum by (level) (count_over_time({%s} 
        |~ "$regex_search"
        %s
        [$__interval]))
      ||| % [
        variables.queriesSelector,
        self.formatParser,
      ]
    )
    + lokiQuery.withLegendFormat('{{ level }}'),
}
