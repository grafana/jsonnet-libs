local g = import '../../../g.libsonnet';
local base = import './main.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local fieldConfig = g.panel.timeSeries.fieldConfig;
// Styly to display Top K metrics that can go from 0 to 100%.
base {
  new(
    title,
    target,
    topk=25,
    legendLabels,
    description='Top %s' % topk):

    local topTarget = target
      + {expr: 'topk('+topk+','+target.expr+')'}
      + g.query.prometheus.withLegendFormat(
        std.join(': ',std.map(function(l) '{{'+l+'}}', legendLabels)));
    local meanTarget = target 
      + {expr: 'avg('+target.expr+')'}
      + g.query.prometheus.withLegendFormat('Mean');
        super.base.new(title, targets=[topTarget,meanTarget], description=description)
      + self.stylize()
      + self.withDataLink("t", "b"),
  withDataLink(title, url):

      {
        links+:
        [
          {
            url: "d/nodes?var-instance=${__field.labels.instance}&${__url_time_range}&var-datasource=${datasource}",
            title: "abc"
          }
        ]
      },
  stylize():
    base.percentage.stylize()
    // make dots cloud
    // + fieldConfig.defaults.custom.withLineStyleMixin(
    // {
    //   fill: 'dot',
    //   dash: [0,40],
    // })
    + fieldConfig.defaults.custom.withFillOpacity(1)
    + fieldConfig.defaults.custom.withLineWidth(1)
    + timeSeries.options.legend.withDisplayMode('table')
      + timeSeries.options.legend.withPlacement('right')
      + timeSeries.options.legend.withCalcsMixin([
          'mean','max','lastNotNull',
      ])
    + timeSeries.standardOptions.withOverrides(
      fieldOverride.byName.new('Mean')
      + fieldOverride.byName.withPropertiesFromOptions(
          fieldConfig.defaults.custom.withLineStyleMixin(
          {
            fill: 'dash',
            dash: [10,10],
          }
        )
        + fieldConfig.defaults.custom.withFillOpacity(0)
        + timeSeries.standardOptions.color.withMode('fixed')
        + timeSeries.standardOptions.color.withFixedColor('light-purple'),
      )
  ),
}
