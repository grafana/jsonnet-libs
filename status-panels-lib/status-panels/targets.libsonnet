local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local prometheusQuery = g.query.prometheus;
local lokiQuery = g.query.loki;
function(
  type,
  datasourceName,
  statusPanelsQuery,
) {
  statusPanelsTarget::
    if type == 'metrics' then
      prometheusQuery.new(
        datasource=datasourceName,
        expr=|||
          %s
        ||| % [
          statusPanelsQuery,
        ]
      )
    else if type == 'logs' then
      lokiQuery.new(
        datasource=datasourceName,
        expr=|||
          %s
        ||| % [
          statusPanelsQuery,
        ]
      ),
}
