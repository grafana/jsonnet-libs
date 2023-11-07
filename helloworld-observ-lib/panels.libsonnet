local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,
      // create stat panel using commonlib
      statPanel1:
        commonlib.panels.generic.stat.base.new(
          'Stat panel 1',
          targets=[t.metric1],
          description='Commonlib description override'
        )
        + g.panel.stat.standardOptions.withUnit('short'),
      // create ts panel using commonlib
      timeSeriesPanel1:
        commonlib.panels.generic.timeSeries.base.new(
          'TS panel 1',
          targets=[
            t.metric2,
          ],
          description=|||
            Panel 1 description
          |||
        )
        + g.panel.timeSeries.standardOptions.withUnit('short'),
      // create panel using grafonnet directly
      // https://grafana.github.io/grafonnet/API/panel/index.html
      timeSeriesPanel2:
        g.panel.timeSeries.new(title='TS Panel 2')
        + g.panel.timeSeries.queryOptions.withTargets([t.metric3])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.panelOptions.withDescription('Description here'),

      overviewTable1:
        g.panel.table.new(
          title='Table 1'
        )
        + g.panel.table.queryOptions.withTargets([t.metric3, t.metric2])
        + g.panel.table.panelOptions.withDescription('Table description here'),

    },
}
