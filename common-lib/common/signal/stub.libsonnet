local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local signalUtils = import './utils.libsonnet';
{
  new(
    signalName,
    type,
  ): {
    local this = self,
    signalName:: signalName,
    withTopK(limit): this,
    withOffset(offset): this,
    withFilteringSelectorMixin(mixin): this,
    withExprWrappersMixin(wrappers=[]): this,
    withLegendFormat(legendFormat): this,
    withHideNameInLegend(hide=true): this,
    withName(name): this,
    withNameShort(name): this,
    withAgglevel(aggLevel): this,
    withAggFunction(aggFunction): this,
    withInstanceLabels(labels): this,
    withInstanceLabelsMixin(labels): this,
    withGroupLabels(labels): this,
    withGroupLabelsMixin(labels): this,
    withInterval(interval): this,
    withAlertsInterval(interval): this,
    withRangeFunction(rangeFunction): this,
    withQuantile(quantile=0.95): this,
    asOverride(name=this.signalName, override='byQuery', format='time_series'): {},
    asTarget():: {},
    asTableTarget():: {},

    //Return as grafana panel mixin target(query+legend) + overrides(like units)
    asPanelMixin():: {},

    asPanelExpression():: {},
    //Return query, usable in alerts/recording rules. No aggregation is applied.
    asRuleExpression():: {},
    //Return as timeSeriesPanel
    asTimeSeries(name=this.signalName)::
      g.panel.text.new('')
      + g.panel.text.panelOptions.withTransparent(true)
      + g.panel.text.panelOptions.withDescription(name + ': Signal not found.')
      + g.panel.text.options.withContent(''),

    //Return as statPanel
    asStat(name=this.signalName)::
      self.asTimeSeries(),

    asTable(name=this.signalName, format)::
      self.asTimeSeries(),

    asStatusHistory(name=this.signalName)::
      self.asTimeSeries(),

    //Return as timeSeriesPanel
    asGauge(name=this.signalName)::
      self.asTimeSeries(),

    asTableColumn(override='byName', format='table'):: {},
  },

}
