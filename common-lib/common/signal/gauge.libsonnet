local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local signalUtils = import './utils.libsonnet';

{
  new(
    name,
    type,
    unit,
    description,
    expr,
    aggLevel,
    vars,
    datasource
  ): {
    local prometheusQuery = g.query.prometheus,
    local lokiQuery = g.query.loki,

    //Return as grafana panel target(query+legend)
    asTarget():
      prometheusQuery.new(
        datasource,
        signalUtils.wrapExpr(type, expr, q=0.95, aggLevel=aggLevel) % vars
      )
      + prometheusQuery.withLegendFormat(signalUtils.wrapLegend(name, aggLevel) % vars),

    //Return as alert/recordingRule query
    asPromRule(): {},

    common::
      // override panel-wide --mixed-- datasource
      prometheusQuery.withDatasource(datasource),
    //Return as timeSeriesPanel
    asTimeSeries():
      g.panel.timeSeries.new(name)
      + self.common
      + g.panel.timeSeries.standardOptions.withUnit(signalUtils.generateUnits(type, unit))
      + g.panel.timeSeries.queryOptions.withTargets(
        self.asTarget()
      ),

    //Return as statPanel
    asStat(): {},

    //Return as timeSeriesPanel
    asGauge(): {},
  },

}
