local g = import '../g.libsonnet';
local panels = import '../panels.libsonnet';
local utils = import '../utils.libsonnet';
local signalUtils = import './utils.libsonnet';

//_info prometheus metric: something_info{<labels>}=1
{
  new(
    name,
    type,
    infoLabel,
    description,
    expr,
    aggLevel,
    vars,
    datasource,
  ):
    {
      local prometheusQuery = g.query.prometheus,
      local lokiQuery = g.query.loki,


      //Return as grafana panel target(query+legend)
      asTarget()::
        prometheusQuery.new(
          datasource,
          signalUtils.wrapExpr(type, expr, q=0.95, aggLevel=aggLevel) % vars
        )
        + prometheusQuery.withLegendFormat(signalUtils.wrapLegend(name, aggLevel) % vars)
        + prometheusQuery.withFormat('table'),

      //Return as alert/recordingRule query
      asPromRule():: {},

      common::
        // override panel-wide --mixed-- datasource
        prometheusQuery.withDatasource(datasource),
      //Return as timeSeriesPanel
      asTimeSeries()::
        error 'asTimeSeries() is not supported for info metrics. Use asStat() instead.',

      //Return as statPanel
      asStat()::
        g.panel.stat.new(name)
        + self.common
        + g.panel.stat.queryOptions.withTargets(
          self.asTarget()
        )
        + panels.generic.stat.info.stylize()
          { options+: { reduceOptions+: { fields: '/^' + infoLabel + '$/' } } },


      //Return as gauge panel
      asGauge()::
        error 'asGauge() is not supported for info metrics. Use asStat() instead.',
    },

}
