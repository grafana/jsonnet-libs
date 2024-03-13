local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local signalUtils = import './utils.libsonnet';

{
  new(
    name,
    type,
  ): {

    asTarget():: {},

    //Return as grafana panel mixi target(query+legend) + overrides(like units)
    asPanelMixin():: {},

    //Return as alert/recordingRule query
    asPromRule():: {},

    //Return as timeSeriesPanel
    asTimeSeries()::
      g.panel.text.new('')
      + g.panel.text.panelOptions.withTransparent(true)
      + g.panel.text.panelOptions.withDescription(name + ': Signal not found.')
      + g.panel.text.options.withContent(''),

    //Return as statPanel
    asStat()::
      self.asTimeSeries(),

    //Return as timeSeriesPanel
    asGauge()::
      self.asTimeSeries(),
  },

}
