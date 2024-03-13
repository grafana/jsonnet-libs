local g = import '../g.libsonnet';
local panels = import '../panels.libsonnet';
local utils = import '../utils.libsonnet';
local base = import './base.libsonnet';
local signalUtils = import './utils.libsonnet';

//_info prometheus metric: something_info{<labels>}=1
base {
  new(
    name,
    type,
    infoLabel,
    description,
    expr,
    aggLevel,
    vars,
    datasource,
    valueMapping,
    legendCustomTemplate,
  ):
    base.new(
      name,
      type,
      'short',
      description,
      expr,
      aggLevel,
      vars,
      datasource,
      valueMapping,
      legendCustomTemplate,
      rangeFunction=null,
    )
    {
      local prometheusQuery = g.query.prometheus,
      local lokiQuery = g.query.loki,

      unit:: 'short',
      //Return as grafana panel target(query+legend)
      asTarget()::
        super.asTarget()
        + prometheusQuery.withFormat('table'),

      //Return as alert/recordingRule query
      asPromRule():: {},

      //Return as timeSeriesPanel
      asTimeSeries()::
        error 'asTimeSeries() is not supported for info metrics. Use asStat() instead.',

      //Return as statPanel
      asStat()::
        super.asStat()
        + panels.generic.stat.info.stylize()
          { options+: { reduceOptions+: { fields: '/^' + infoLabel + '$/' } } },

      //Return as gauge panel
      asGauge()::
        error 'asGauge() is not supported for info metrics. Use asStat() instead.',

    },

}
