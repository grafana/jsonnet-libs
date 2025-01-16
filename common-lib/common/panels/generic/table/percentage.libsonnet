local g = import '../../../g.libsonnet';
local table = g.panel.table;
local percentage = import '../timeSeries/percentage.libsonnet';
local fieldOverride = g.panel.timeSeries.fieldOverride;
local fieldConfig = g.panel.timeSeries.fieldConfig;
local base = import './base.libsonnet';
// This panel can be used to display gauge table columns with values from 0 to 100%.
// Examples: CPU utilization, memory utilization etc.
base {

  new(): error 'not supported',
  stylize(): error 'not supported',

  // when attached to table, this function applies style to row named 'name'
  stylizeByName(name):
    table.standardOptions.withOverridesMixin(
      fieldOverride.byName.new(name)
      + fieldOverride.byName.withProperty('custom.cellOptions', { type: 'gauge', mode: 'basic' })
      + fieldOverride.byName.withPropertiesFromOptions(percentage.stylize(allLayers=false)),
    ),
}
