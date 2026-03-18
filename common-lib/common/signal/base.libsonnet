local g = import '../g.libsonnet';
local panels = import '../panels.libsonnet';
local utils = import '../utils.libsonnet';
local signalUtils = import './utils.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
{
  new(
    signalName,
    type,
    unit,
    nameShort,
    description,
    aggLevel,
    aggFunction,
    vars,
    datasource,
    sourceMaps,
  ): {

    local prometheusQuery = g.query.prometheus,
    local this = self,
    local hasValueMaps = std.length(this.getValueMappings(this.sourceMaps)) > 0,

    legendCustomTemplate:: sourceMaps[0].legendCustomTemplate,
    signalName:: signalName,
    nameShort:: nameShort,
    hideNameInLegend:: false,
    legendBase:: if this.hideNameInLegend then '' else this.nameShort,
    description:: description,
    aggLevel:: aggLevel,
    sourceMaps:: sourceMaps,
    combineUniqueExpressions(expressions)::
      std.join(
        if type == 'info' then '\nor ignoring(%s)\n' % std.join(',', this.combineUniqueInfoLabels(sourceMaps)) else '\nor\n',
        std.uniq(  // keep unique only
          std.sort(expressions)
        )
      ),

    combineUniqueKeepLabels(sourceMaps)::
      std.uniq(  // keep unique only
        std.sort(
          std.foldl(function(total, source)
            total
            + std.get(source, 'aggKeepLabels', [])
                    , sourceMaps, init=[]),
        )
      ),
    combineUniqueInfoLabels(sourceMaps)::
      std.uniq(  // keep unique only
        std.sort(
          std.foldl(function(total, source)
            total
            //keep infoLabel as well
            + std.prune([std.get(source, 'infoLabel')])
                    , sourceMaps, init=[]),
        )
      ),
    // Return description for accumulation
    wrapDescription()::
      this.nameShort + ' (' + this.vars.aggFunction + ')' + ': ' + this.description,

    // Render description for panel. Uses accumulated descriptions.
    // If multiple descriptions are present, join them with double newlines.
    // Else use single description as is.
    renderDescription()::
      {
        description:
          if std.length(super._descriptionsAccumulator) > 1
          then std.join('  \n\n', std.map(function(x) x, super._descriptionsAccumulator))
          else if std.length(super._descriptionsAccumulator) == 1
          then super._descriptionsAccumulator[0] + '  \n'
          else this.description,
      },

    //calculate aggKeepLabels to be used in legendLabelsCalculation
    aggKeepLabels:: self.combineUniqueKeepLabels(this.sourceMaps),
    infoLabels:: self.combineUniqueInfoLabels(this.sourceMaps),
    vars::
      vars
      {
        //add additional templatedVars
        aggLabels:
          []
          + (
            if this.aggLevel == 'group' then super.groupLabels
            else if this.aggLevel == 'instance' then super.groupLabels + super.instanceLabels
            else if this.aggLevel == 'none' || this.aggLevel == 'aggKeepLabels' then []
          )
          + (
            if std.length(this.aggKeepLabels) > 0 then this.aggKeepLabels
            else []
          )
          + (
            if std.length(this.infoLabels) > 0 then this.infoLabels
            else []
          ),
        agg: std.join(',', self.aggLabels),

        //prefix for legend when aggregation is used
        local legendLabels =
          []
          +
          (
            if this.aggLevel == 'group' then super.groupLabels
            else if this.aggLevel == 'instance' then super.instanceLabels
            else if this.aggLevel == 'none' || this.aggLevel == 'aggKeepLabels' then super.instanceLabels
          ),
        aggLegend: utils.labelsToPanelLegend(
          // keep last label
          xtd.array.slice(legendLabels, -1)
        ),
        keepLabelsLegend: if std.length(this.aggKeepLabels) > 0
        then utils.labelsToPanelLegend(this.aggKeepLabels, separator=' ')
        else '',
        aggFunction: aggFunction,
      },

    unit:: signalUtils.generateUnits(type, unit, this.sourceMaps[0].rangeFunction),

    withUnit(unit):
      this
      {
        unit:: unit,
      },

    withOffset(offset):
      this
      {
        sourceMaps:
          [
            source
            {
              expr: '(%s offset %s)' % [source.expr, offset],
            }
            for source in this.sourceMaps
          ],
      },

    withFilteringSelectorMixin(mixin):
      this
      {
        vars+::
          {
            filteringSelector:
              [
                std.join(
                  ',',
                  std.filter(function(x) std.length(x) > 0, [
                    this.vars.filteringSelector[0],
                    mixin,
                  ])
                ),
              ],
            queriesSelector+: ',' + mixin,
            queriesSelectorGroupOnly+: ',' + mixin,
            queriesSelectorFilterOnly+: ',' + mixin,
          },
      },

    withTopK(limit=25):
      this
      {
        sourceMaps:
          [
            source
            {
              exprWrappers+: [
                [
                  'topk(' + limit + ',',
                  ')',
                ],
              ],
            }
            for source in this.sourceMaps
          ],
      },

    withExprWrappersMixin(wrappers=[]):
      this
      {
        sourceMaps:
          [
            source
            {
              exprWrappers+: [wrappers],
            }
            for source in this.sourceMaps
          ],
      },

    withLegendFormat(legendFormat):
      this
      {
        legendCustomTemplate:: legendFormat,
      },
    withHideNameInLegend(hide=true):
      this
      {
        hideNameInLegend:: hide,
      },
    withName(name):
      this
      {
        signalName:: name,
      },
    withNameShort(name):
      this
      {
        nameShort:: name,
      },
    withAgglevel(aggLevel):
      this
      {
        aggLevel:: aggLevel,
      },
    withAggFunction(aggFunction):
      this
      {
        vars+:: {
          aggFunction: aggFunction,
        },
      },
    withInstanceLabels(labels):
      this
      {
        vars+:: {
          instanceLabels: labels,
        },
      },
    withInstanceLabelsMixin(labels):
      this
      {
        vars+:: {
          instanceLabels+: labels,
        },
      },
    withGroupLabels(labels):
      this
      {
        vars+:: {
          groupLabels: labels,
        },
      },
    withGroupLabelsMixin(labels):
      this
      {
        vars+:: {
          groupLabels+: labels,
        },
      },
    withInterval(interval):
      this
      {
        vars+:: {
          interval: interval,
        },
      },
    withAlertsInterval(interval):
      this
      {
        vars+:: {
          alertsInterval: interval,
        },
      },
    withRangeFunction(rangeFunction):
      this
      {
        sourceMaps:
          [
            source
            {
              rangeFunction: rangeFunction,
            }
            for source in this.sourceMaps
          ],
      },

    //Return as grafana panel target(query+legend)
    asTarget(name=this.signalName):
      prometheusQuery.new(
        '${%s}' % datasource,
        self.asPanelExpression(),
      )
      + prometheusQuery.withRefId(name)
      + prometheusQuery.withLegendFormat(signalUtils.wrapLegend(this.legendBase, this.aggLevel, this.legendCustomTemplate, this.aggKeepLabels) % this.vars)
      + prometheusQuery.withFormat('time_series')
      + prometheusQuery.withInstant(false),

    //Useful to compose table with instant values
    asTableTarget():
      self.asTarget()
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),

    //Return as grafana panel mixin target(query+legend) + overrides(like units)
    asPanelMixin(override='byQuery'):
      { _descriptionsAccumulator+:: [this.wrapDescription()] }
      + g.panel.timeSeries.queryOptions.withTargetsMixin(self.asTarget())
      // This is required for perses migrations mostly
      + g.panel.timeSeries.standardOptions.withUnit(self.unit)
      + self.asOverride(override=override)
      + self.renderDescription(),

    //Return table target (instant=true, format=table) + overrides
    asTableColumn(override='byName', format='table'):
      { _descriptionsAccumulator+:: [this.wrapDescription()] }
      + g.panel.table.queryOptions.withTargetsMixin(
        if format == 'table' then self.asTableTarget()
        else if format == 'time_series' then self.asTarget()
        else error 'Unknown format, must be "table" or "time_series"'
      )
      + self.asOverride(override=override, format=format)
      + self.renderDescription(),

    getValueMappings(sourceMaps)::
      std.uniq(
        std.foldl(function(total, source) total + std.get(source, 'valueMappings', []), sourceMaps, init=[])
      ),

    asOverride(name=this.signalName, override='byQuery', format='time_series'):
      g.panel.timeSeries.standardOptions.withOverridesMixin(
        [
          if override == 'byQuery' then
            g.panel.timeSeries.fieldOverride.byQuery.new(name)
            + (if format == 'table' && hasValueMaps then g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' }) else {})
            + (if format == 'table' && type == 'info' then g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true) else {})
            + (if format == 'table' && type != 'info' && name != this.nameShort then g.panel.table.fieldOverride.byName.withProperty('displayName', utils.toSentenceCase(this.nameShort)) else {})
            + g.panel.timeSeries.fieldOverride.byQuery.withPropertiesFromOptions(
              (if hasValueMaps then
                 g.panel.timeSeries.standardOptions.withMappings(this.getValueMappings(sourceMaps))
               else {})
              + g.panel.timeSeries.standardOptions.withUnit(self.unit)
            )
          else if override == 'byName' then
            g.panel.timeSeries.fieldOverride.byName.new(name)
            + (if format == 'table' && hasValueMaps then g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' }) else {})
            + (if format == 'table' && type == 'info' then g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true) else {})
            + (if format == 'table' && type != 'info' && name != this.nameShort then g.panel.table.fieldOverride.byName.withProperty('displayName', utils.toSentenceCase(this.nameShort)) else {})
            + g.panel.timeSeries.fieldOverride.byName.withPropertiesFromOptions(
              (if hasValueMaps then
                 g.panel.timeSeries.standardOptions.withMappings(this.getValueMappings(sourceMaps))
               else {})
              + g.panel.timeSeries.standardOptions.withUnit(self.unit)
            )
          else error 'Unknown override type, only "byName", "byQuery" are supported.',
        ],
      )
      + (if type == 'info' && format == 'table' then
           g.panel.timeSeries.standardOptions.withOverridesMixin(
             [
               g.panel.timeSeries.fieldOverride.byName.new(infoLabel)
               + g.panel.table.fieldOverride.byName.withProperty('displayName', utils.toSentenceCase(this.nameShort))
               for infoLabel in this.infoLabels
             ],
           )
         else {}),
    //Return query
    asPanelExpression():
      self.combineUniqueExpressions(
        [
          //override aggLabels for specific source.
          local aggLabels =
            []
            + (
              if this.aggLevel == 'group' then this.vars.groupLabels
              else if this.aggLevel == 'instance' then this.vars.groupLabels + this.vars.instanceLabels
              else if this.aggLevel == 'none' || this.aggLevel == 'aggKeepLabels' then []
            )
            + (
              if std.length(source.aggKeepLabels) > 0 then source.aggKeepLabels
              else []
            )
            + (
              //keep infoLabel as well when aggregating info signals
              if source.infoLabel != null then [source.infoLabel]
              else []
            );
          signalUtils.wrapExpr(
            type,
            source.expr,
            exprWrappers=std.get(source, 'exprWrappers', default=[]),
            q=std.get(this, 'quantile', default=0.95),
            aggLevel=this.aggLevel,
            rangeFunction=source.rangeFunction,
            alertRule=false,
            interval=this.vars.interval,
          ).applyFunctions()
          % this.vars {
            agg: std.join(',', aggLabels),
          }
          for source in this.sourceMaps
        ]
      ),

    //Return query, usable in alerts/recording rules.
    asRuleExpression():
      self.combineUniqueExpressions(
        [
          //override aggLevel to 'none', to avoid losing labels in alerts due to by() clause:
          signalUtils.wrapExpr(
            type,
            source.expr,
            exprWrappers=std.get(source, 'exprWrappers', default=[]),
            q=std.get(this, 'quantile', default=0.95),
            aggLevel='none',
            rangeFunction=source.rangeFunction,
            // ensure that interval doesn't have Grafana dashboard dynamic intervals:
            alertRule=true,
            interval=this.vars.interval,
          ).applyFunctions()
          % this.vars
            {  // ensure that interval doesn't have Grafana dashboard dynamic intervals:
            interval: this.vars.alertsInterval,
            // keep only filteringSelector, remove any Grafana dashboard variables:
            queriesSelector: this.vars.filteringSelector[0],
            queriesSelectorGroupOnly: this.vars.filteringSelector[0],
            queriesSelectorFilterOnly: this.vars.filteringSelector[0],
          }
          for source in this.sourceMaps
        ]
      ),

    common(type)::
      (
        // For table, asTableColumn() fills _descriptionsAccumulator; leave it empty here so only one description is added.
        if type == 'table' then { _descriptionsAccumulator:: [] }
        else { description: this.description, _descriptionsAccumulator:: [this.wrapDescription()] }
      )
      // override panel-wide --mixed-- datasource
      + prometheusQuery.withDatasource('${%s}' % datasource)
      // This is required for perses migrations mostly
      + g.panel.timeSeries.standardOptions.withUnit(self.unit)
      + (
        if type == 'table' then {}
        else
          g.panel.timeSeries.queryOptions.withTargets(
            self.asTarget()
          )
          + self.asOverride()
      ),

    //Return as timeSeriesPanel
    asTimeSeries(name=this.signalName):
      g.panel.timeSeries.new(name)
      + self.common(type='timeSeries'),

    //Return as statPanel
    asStat(name=this.signalName):
      g.panel.stat.new(name)
      + self.common(type='stat'),
    // Return as table
    // Table format: all targets must have format=table, instant=true, and matching labels set.
    // Timeseries format: all targets must have format=timeseries, instant=false, and matching labels set.
    // Useful to show Table trends.
    asTable(name=this.signalName, format='table', filterable=false):
      g.panel.table.new(name)
      // https://github.com/grafana/grafonnet/issues/238
      // + g.panel.table.standardOptions.withFilterable(value=filterable)
      + {
        fieldConfig+: {
          defaults+: {
            custom+: {
              filterable: filterable,
            },
          },
        },
      }
      + self.common(type='table')
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
            g.panel.table.queryOptions.transformation.withId('organize')
            + g.panel.table.queryOptions.transformation.withOptions(
              {
                indexByName: {
                  [label.el]: label.index
                  for label in
                    std.mapWithIndex(function(i, e) { index: i, el: e }, this.vars.aggLabels)
                },
                renameByName:
                  // If 'Value' is still present, then rename value to signal name.
                  // this is the case if only single query is used in the table.
                  {
                    Value: name,
                  }
                  +
                  {
                    [label]: utils.toSentenceCase(label)
                    for label in this.vars.aggLabels
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
    asGauge(name=this.signalName):
      g.panel.gauge.new(name)
      + self.common(type='gauge'),
    //Return as statusHistory
    asStatusHistory(name=this.signalName):
      g.panel.statusHistory.new(name)
      + self.common(type='status-history')
      // limit number of DPs
      + g.panel.statusHistory.queryOptions.withMaxDataPoints(100)
      + g.panel.statusHistory.standardOptions.color.withMode('fixed')
      + g.panel.statusHistory.options.withShowValue('never'),

  },

}
