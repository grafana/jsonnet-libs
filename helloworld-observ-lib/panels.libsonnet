local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,
      // create stat panel using commonlib
      statPanel1:
        this.signals.uptime1.asStat(),
      // create ts panel using commonlib
      timeSeriesPanel1:
        this.signals.metric1.asTimeSeries(),

      timeSeriesPanel2:
        this.signals.metric2.asTimeSeries(),

      // with multiple metrics:
      timeSeriesPanel3:
        g.panel.timeSeries.new('Panel3')
        + g.panel.timeSeries.withDescription('Some description.')
        + this.signals.metric2.asPanelMixin()
        + this.signals.metric3.asPanelMixin(),

      overviewTable1:
        g.panel.table.new(
          title='Table 1'
        )
        + g.panel.table.queryOptions.withTargets(
          [
            this.signals.metric2.asTarget(),
            this.signals.metric1.asTarget(),
            this.signals.metric3.asTarget(),
          ]
        )
        + g.panel.table.panelOptions.withDescription('Table description here'),

    },
}
