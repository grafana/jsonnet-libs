local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local signalUtils = import './utils.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
{
  new(
    signalName,
    type,
    unit,
    description,
    aggLevel,
    aggFunction,
    vars,
    datasource,
    sourceMaps,
  ): {

    local prometheusQuery = g.query.prometheus,
    local lokiQuery = g.query.loki,
    local this = self,

    local legendCustomTemplate = sourceMaps[0].legendCustomTemplate,

    combineUniqueExpressions(expressions)::
      std.join(
        '\nor\n',
        std.uniq(  // keep unique only
          std.sort(expressions)
        )
      ),

    combineUniqueKeepLabels(sourceMaps)::
      std.uniq(  // keep unique only
        std.sort(
          std.foldl(function(total, source) total + std.get(source, 'aggKeepLabels', []), sourceMaps, init=[]),
        )
      ),

    //calculate aggKeepLabels to be used in legendLabelsCalculation
    local aggKeepLabels = self.combineUniqueKeepLabels(sourceMaps),
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
        aggLegend: utils.labelsToPanelLegend(xtd.array.slice(legendLabels, -1)),
        aggFunction: aggFunction,
      },


    unit:: signalUtils.generateUnits(type, unit, sourceMaps[0].rangeFunction),
    //Return as grafana panel target(query+legend)
    asTarget(name=signalName)::
      prometheusQuery.new(
        '${%s}' % datasource,
        self.asPanelExpression(),
      )
      + prometheusQuery.withRefId(name)
      + prometheusQuery.withLegendFormat(signalUtils.wrapLegend(name, aggLevel, legendCustomTemplate) % this.vars)
      + prometheusQuery.withFormat('time_series')
      + prometheusQuery.withInstant(false),

    //Useful to compose table with instant values
    asTableTarget()::
      self.asTarget()
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),

    //Return as grafana panel mixin target(query+legend) + overrides(like units)
    asPanelMixin(override='byQuery')::
      g.panel.timeSeries.queryOptions.withTargetsMixin(self.asTarget())
      + self.asOverride(override=override),

    //Return table target (instant=true, format=table) + overrides
    asTableColumn(override='byName', format='table')::
      g.panel.table.queryOptions.withTargetsMixin(
        if format == 'table' then self.asTableTarget()
        else if format == 'time_series' then self.asTarget()
        else error 'Unknown format, must be "table" or "time_series"'
      )
      + self.asOverride(override=override),


    getValueMappings(sourceMaps):
      std.foldl(function(total, source) total + std.get(source, 'valueMappings', []), sourceMaps, init=[]),

    asOverride(name=signalName, override='byQuery')::
      g.panel.timeSeries.standardOptions.withOverridesMixin(
        [
          if override == 'byQuery' then
            g.panel.timeSeries.fieldOverride.byQuery.new(name)
            + g.panel.timeSeries.fieldOverride.byQuery.withPropertiesFromOptions(
              g.panel.timeSeries.standardOptions.withUnit(self.unit)
              + g.panel.timeSeries.standardOptions.withMappings(this.getValueMappings(sourceMaps))
            )
          else if override == 'byName' then
            g.panel.timeSeries.fieldOverride.byName.new(name)
            + g.panel.timeSeries.fieldOverride.byName.withPropertiesFromOptions(
              g.panel.timeSeries.standardOptions.withUnit(self.unit)
              + g.panel.timeSeries.standardOptions.withMappings(this.getValueMappings(sourceMaps))
            )
          else error 'Unknown override type, only "byName", "byQuery" are supported.',
        ],
      ),

    //Return query
    asPanelExpression()::
      self.combineUniqueExpressions(
        [
          //override aggLabels for specific source.
          local aggLabels =
            []
            + (
              if aggLevel == 'group' then this.vars.groupLabels
              else if aggLevel == 'instance' then this.vars.groupLabels + this.vars.instanceLabels
              else if aggLevel == 'none' then []
            )
            + (
              if std.length(source.aggKeepLabels) > 0 then source.aggKeepLabels
              else []
            );
          local vars = this.vars { agg: std.join(',', aggLabels) };
          signalUtils.wrapExpr(
            type,
            source.expr,
            exprWrappers=std.get(source, 'exprWrappers', default=[]),
            aggLevel=aggLevel,
            rangeFunction=source.rangeFunction,
          ).applyFunctions()
          % vars
          for source in sourceMaps
        ]
      ),

    //Return query, usable in alerts/recording rules.
    asRuleExpression()::
      self.combineUniqueExpressions(
        [
          //override aggLevel to 'none', to avoid loosing labels in alerts due to by() clause:
          signalUtils.wrapExpr(
            type,
            source.expr,
            exprWrappers=std.get(source, 'exprWrappers', default=[]),
            aggLevel='none',
            rangeFunction=source.rangeFunction,
          ).applyFunctions()
          % this.vars
            {  // ensure that interval doesn't have Grafana dashboard dynamic intervals:
            interval: this.vars.alertsInterval,
            // keep only filteringSelector, remove any Grafana dashboard variables:
            queriesSelector: this.vars.filteringSelector[0],
          }
          for source in sourceMaps
        ]
      ),


    common::
      // override panel-wide --mixed-- datasource
      prometheusQuery.withDatasource('${%s}' % datasource)
      + g.panel.timeSeries.panelOptions.withDescription(description)
      + g.panel.timeSeries.queryOptions.withTargets(
        self.asTarget()
      )
      + self.asOverride(),

    //Return as timeSeriesPanel
    asTimeSeries(name=signalName)::
      g.panel.timeSeries.new(name)
      + self.common,

    //Return as statPanel
    asStat(name=signalName)::
      g.panel.stat.new(name)
      + self.common,
    // Return as table
    // Table format: all targets must have format=table, instant=true, and matching labels set.
    // Timeseries format: all targets must have format=timeseries, instant=false, and matching labels set.
    // Useful to show Table trends.
    asTable(name=signalName, format='table')::
      prometheusQuery.withDatasource('${%s}' % datasource)
      + g.panel.table.new(name)
      +
      if format == 'table' then
        self.asTableColumn()
        + g.panel.table.queryOptions.withTransformations(
          [
            g.panel.table.queryOptions.transformation.withId('merge'),
            g.panel.table.queryOptions.transformation.withId('renameByRegex')
            + g.panel.table.queryOptions.transformation.withOptions({
              regex: 'Value #(.*)',
              renamePattern: '$1',
            }),
            g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
            + g.panel.table.queryOptions.transformation.withOptions(
              {
                include: {
                  pattern: '^(?!Time).*$',
                },
              }
            ),
          ]
        )
      else if format == 'time_series' then
        self.asPanelMixin(override='byName')
        + g.panel.table.queryOptions.withTransformations(
          [
            g.panel.table.queryOptions.transformation.withId('timeSeriesTable'),
            g.panel.table.queryOptions.transformation.withId('merge'),
            g.panel.table.queryOptions.transformation.withId('renameByRegex')
            + g.panel.table.queryOptions.transformation.withOptions({
              regex: 'Trend #(.*)',
              renamePattern: '$1',
            }),
          ]
        )
      else error 'Table format must be "time_series" or "table"',


    //Return as gauge panel
    asGauge(name=signalName)::
      g.panel.gauge.new(name)
      + self.common,
    //Return as statusHistory
    asStatusHistory(name=signalName)::
      g.panel.statusHistory.new(name)
      + self.common
      // limit number of DPs
      + g.panel.statusHistory.queryOptions.withMaxDataPoints(100)
      + g.panel.statusHistory.standardOptions.color.withMode('fixed')
      + g.panel.statusHistory.options.withShowValue('never'),

  },

}
