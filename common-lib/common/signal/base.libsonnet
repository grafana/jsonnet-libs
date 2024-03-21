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
    datasource,
    valueMapping,
    legendCustomTemplate,
    rangeFunction,
  ): {
    local prometheusQuery = g.query.prometheus,
    local lokiQuery = g.query.loki,

    unit:: signalUtils.generateUnits(type, unit, rangeFunction),
    //Return as grafana panel target(query+legend)
    asTarget()::
      prometheusQuery.new(
        datasource,
        self.asPanelExpression(),
      )
      + prometheusQuery.withRefId(name)
      + prometheusQuery.withLegendFormat(signalUtils.wrapLegend(name, aggLevel, legendCustomTemplate) % vars),

    //Return as grafana panel mixi target(query+legend) + overrides(like units)
    asPanelMixin()::
      g.panel.timeSeries.queryOptions.withTargetsMixin(self.asTarget())
      + g.panel.timeSeries.standardOptions.withOverridesMixin(
        [
          g.panel.timeSeries.fieldOverride.byQuery.new(name)
          + g.panel.timeSeries.fieldOverride.byQuery.withPropertiesFromOptions(
            g.panel.timeSeries.standardOptions.withUnit(self.unit)
            + g.panel.timeSeries.standardOptions.withMappings(valueMapping)
          ),
        ],
      ),

    //Return query
    asPanelExpression()::
      signalUtils.wrapExpr(type, expr, q=0.95, aggLevel=aggLevel, rangeFunction=rangeFunction) % vars,
    //Return query, usable in alerts/recording rules.
    asRuleExpression()::
      signalUtils.wrapExpr(type, expr, q=0.95, aggLevel=aggLevel, rangeFunction=rangeFunction)
      % vars
        {  // ensure that interval doesn't have Grafana dashboard dynamic intervals:
        interval: vars.alertsInterval,
        // keep only filteringSelector, remove any Grafana dashboard variables:
        queriesSelector: vars.filteringSelector[0],
        // never aggregate if rule to avoid lossing labels.
        aggLegend: 'none',
      },


    common::
      // override panel-wide --mixed-- datasource
      prometheusQuery.withDatasource(datasource)
      + g.panel.timeSeries.panelOptions.withDescription(description)
      + g.panel.timeSeries.standardOptions.withUnit(self.unit)
      + g.panel.timeSeries.standardOptions.withMappings(valueMapping)
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

    //Return as gauge panel
    asGauge()::
      g.panel.gauge.new(name)
      + self.common,
    //Return as statusHistory
    asStatusHistory()::
      g.panel.statusHistory.new(name)
      + self.common
      // limit number of DPs
      + g.panel.statusHistory.queryOptions.withMaxDataPoints(100)
      + g.panel.statusHistory.standardOptions.color.withMode('fixed')
      + g.panel.statusHistory.options.withShowValue('never'),

  },

}
