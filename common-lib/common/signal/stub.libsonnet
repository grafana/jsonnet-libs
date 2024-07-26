local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local signalUtils = import './utils.libsonnet';

{
  new(
    signalName,
    type,
  ): {

    asTarget():: {},
    asTableTarget:: {},

    //Return as grafana panel mixin target(query+legend) + overrides(like units)
    asPanelMixin():: {},

    asPanelExpression():: {},
    //Return query, usable in alerts/recording rules. No aggregation is applied.
    asRuleExpression():: {},
    //Return as timeSeriesPanel
    asTimeSeries(name=signalName)::
      g.panel.text.new('')
      + g.panel.text.panelOptions.withTransparent(true)
      + g.panel.text.panelOptions.withDescription(name + ': Signal not found.')
      + g.panel.text.options.withContent(''),

    //Return as statPanel
    asStat(name=signalName)::
      self.asTimeSeries(),

    asTable(name=signalName, format)::
      self.asTimeSeries(),

    //Return as timeSeriesPanel
    asGauge(name=signalName)::
      self.asTimeSeries(),
    asTableColumn(override, format):: {},
  },

}
