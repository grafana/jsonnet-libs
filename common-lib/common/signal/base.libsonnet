local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local signalUtils = import './utils.libsonnet';

{
  new(
    name,
    type,
    unit,
    description,
    exprBase,
    exprWrappers,
    aggLevel,
    aggFunction,
    aggKeepLabels,
    vars,
    datasource,
    valueMapping,
    legendCustomTemplate,
    rangeFunction,
  ): {
    local prometheusQuery = g.query.prometheus,
    local lokiQuery = g.query.loki,
    local this = self,

    vars::
      vars
      {
        //add additional templatedVars
        local aggLabels =
          []
          + (
            if aggLevel == 'group' then super.groupLabels
            else if aggLevel == 'instance' then super.groupLabels + super.instanceLabels
            else if aggLevel == 'none' then []
          )
          + (
            if std.length(aggKeepLabels) > 0 then aggKeepLabels
            else []
          ),
        agg: std.join(',', aggLabels),

        //prefix for legend when aggregation is used
        local legendLabels =
          []
          +
          (
            if aggLevel == 'group' then super.groupLabels
            else if aggLevel == 'instance' then super.instanceLabels
            else if aggLevel == 'none' then []
          )
          +
          (
            if std.length(aggKeepLabels) > 0 then aggKeepLabels
            else []
          ),
        aggLegend: utils.labelsToPanelLegend(legendLabels),
        aggFunction: aggFunction,
      },


    unit:: signalUtils.generateUnits(type, unit, rangeFunction),
    //Return as grafana panel target(query+legend)
    asTarget()::
      prometheusQuery.new(
        '${%s}' % datasource,
        self.asPanelExpression(),
      )
      + prometheusQuery.withRefId(name)
      + prometheusQuery.withLegendFormat(signalUtils.wrapLegend(name, aggLevel, legendCustomTemplate) % this.vars),

    //Return as grafana panel mixin target(query+legend) + overrides(like units)
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
      signalUtils.wrapExpr(type, exprBase, exprWrappers=exprWrappers, aggLevel=aggLevel, rangeFunction=rangeFunction).applyFunctions()
      % this.vars,
    //Return query, usable in alerts/recording rules.
    asRuleExpression()::
      //override aggLevel to 'none', to avoid loosing labels in alerts due to by() clause:
      signalUtils.wrapExpr(type, exprBase, exprWrappers=exprWrappers, aggLevel='none', rangeFunction=rangeFunction).applyFunctions()
      % this.vars
        {  // ensure that interval doesn't have Grafana dashboard dynamic intervals:
        interval: this.vars.alertsInterval,
        // keep only filteringSelector, remove any Grafana dashboard variables:
        queriesSelector: this.vars.filteringSelector[0],
      },


    common::
      // override panel-wide --mixed-- datasource
      prometheusQuery.withDatasource('${%s}' % datasource)
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
