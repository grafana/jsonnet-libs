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

    unit:: signalUtils.generateUnits(type, unit),
    //Return as grafana panel target(query+legend)
    asTarget()::
      prometheusQuery.new(
        datasource,
        signalUtils.wrapExpr(type, expr, q=0.95, aggLevel=aggLevel) % vars
      )
      + prometheusQuery.withRefId(name)
      + prometheusQuery.withLegendFormat(signalUtils.wrapLegend(name, aggLevel) % vars),

    //Return as grafana panel mixi target(query+legend) + overrides(like units)
    asPanelMixin()::
      g.panel.timeSeries.queryOptions.withTargetsMixin(self.asTarget())
      + g.panel.timeSeries.standardOptions.withOverridesMixin(
        [
          g.panel.timeSeries.fieldOverride.byQuery.new(name)
          + g.panel.timeSeries.fieldOverride.byQuery.withPropertiesFromOptions(
            g.panel.timeSeries.standardOptions.withUnit(self.unit),
          ),
        ],
      ),

    //Return as alert/recordingRule query
    asPromRule():: {},

    common::
      // override panel-wide --mixed-- datasource
      prometheusQuery.withDatasource(datasource)
      + g.panel.timeSeries.panelOptions.withDescription(description)
      + g.panel.timeSeries.standardOptions.withUnit(self.unit)
      + g.panel.timeSeries.queryOptions.withTargets(
        self.asTarget()
      ),

    //Return as timeSeriesPanel
    asTimeSeries()::
      g.panel.timeSeries.new(name)
      + self.common,

    //Return as statPanel
    asStat()::
      g.panel.stat.new(name)
      + self.common,

    //Return as timeSeriesPanel
    asGauge()::
      g.panel.gauge.new(name)
      + self.common,
  },

}
