local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local prometheusQuery = g.query.prometheus;
function(
  type,
  datasourceName,
  statusPanelsQuery,
) {
  statusPanelsTarget::
    prometheusQuery.new(
      datasource=datasourceName,
      expr=|||
        %s
      ||| % [
        statusPanelsQuery,
      ]
    ),
}
