local g = import '../common/g.libsonnet';
local prometheusQuery = g.query.prometheus;
local lokiQuery = g.query.loki;
function(
  datasourceNameMetrics,
  datasourceNameLogs,
  statusPanelsQueryMetrics,
  statusPanelsQueryLogs
) {
  statusPanelsTargetMetrics::
    prometheusQuery.new(
      datasource=datasourceNameMetrics,
      expr=|||
        %s
      ||| % [
        statusPanelsQueryMetrics,
      ]
    ),
  statusPanelsTargetLogs::
    lokiQuery.new(
      datasource=datasourceNameLogs,
      expr=|||
        %s
      ||| % [
        statusPanelsQueryLogs,
      ]
    ),
}
